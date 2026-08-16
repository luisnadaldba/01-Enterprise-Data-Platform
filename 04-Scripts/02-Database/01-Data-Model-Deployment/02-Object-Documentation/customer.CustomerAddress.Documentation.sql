    PRINT N'    customer.CustomerAddress';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @CSTAD_expected_description nvarchar(4000);
    DECLARE @CSTAD_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Maintains the association between customers and their current or historical addresses while storing customer-specific address information.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress';

        PRINT N'        [+] Table description added       : customer.CustomerAddress';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : customer.CustomerAddress';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : customer.CustomerAddress';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_id
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Primary key of customer.CustomerAddress.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_id';

        PRINT N'        [+] Column description added      : CSTAD_id';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_id';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_id';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_CST_id
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Foreign key referencing customer.Customer.CST_id.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_CST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_CST_id';

        PRINT N'        [+] Column description added      : CSTAD_CST_id';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_CST_id';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_CST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_CST_id';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_ADR_id
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Foreign key referencing reference.Address.ADR_id.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_ADR_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_ADR_id';

        PRINT N'        [+] Column description added      : CSTAD_ADR_id';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_ADR_id';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_ADR_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_ADR_id';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_number
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Stores the street number associated with the customer at the referenced address.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_number'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_number';

        PRINT N'        [+] Column description added      : CSTAD_number';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_number';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_number';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_number';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_complement
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Stores optional address information that identifies a unit, apartment, block, suite, or similar location detail.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_complement'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_complement';

        PRINT N'        [+] Column description added      : CSTAD_complement';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_complement';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_complement';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_complement';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_is_primary
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Indicates whether the address is the primary address currently designated for the customer.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_is_primary'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_is_primary';

        PRINT N'        [+] Column description added      : CSTAD_is_primary';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_is_primary';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_is_primary';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_is_primary';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_is_active
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Indicates whether the customer currently maintains an active association with the address while preserving inactive associations for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_is_active';

        PRINT N'        [+] Column description added      : CSTAD_is_active';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_is_active';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_is_active';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_created_at
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_created_at';

        PRINT N'        [+] Column description added      : CSTAD_created_at';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_created_at';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_created_at';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTAD_updated_at
    ----------------------------------------------------------------------*/

    SET @CSTAD_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTAD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerAddress',
            @level2type = N'COLUMN',
            @level2name = N'CSTAD_updated_at';

        PRINT N'        [+] Column description added      : CSTAD_updated_at';

    END
    ELSE
    BEGIN

        SET @CSTAD_existing_description = NULL;

        SELECT
            @CSTAD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'customer.CustomerAddress')
        AND ep.name = N'MS_Description'
        AND c.name = N'CSTAD_updated_at';

        IF @CSTAD_existing_description = @CSTAD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTAD_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTAD_updated_at';
            PRINT N'            Expected                     : '
                + @CSTAD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTAD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CSTAD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CSTAD_existing_description
                END;

        END;

    END;


    PRINT N'';