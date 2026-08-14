    PRINT N'    catalog.ProductAttributeValue';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @PATVL_expected_description nvarchar(4000);
    DECLARE @PATVL_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PATVL_expected_description =
        N'Maintains the controlled set of values available for reusable product attributes.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PATVL_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttributeValue';

        PRINT N'        [+] Table description added       : catalog.ProductAttributeValue';

    END
    ELSE
    BEGIN

        SET @PATVL_existing_description = NULL;

        SELECT
            @PATVL_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';


        IF @PATVL_existing_description = @PATVL_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.ProductAttributeValue';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.ProductAttributeValue';
            PRINT N'            Expected                     : '
                + @PATVL_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PATVL_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PATVL_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PATVL_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PATVL_id
    ----------------------------------------------------------------------*/

    SET @PATVL_expected_description =
        N'Primary key of catalog.ProductAttributeValue.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PATVL_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttributeValue',
            @level2type = N'COLUMN',
            @level2name = N'PATVL_id';

        PRINT N'        [+] Column description added      : PATVL_id';

    END
    ELSE
    BEGIN

        SET @PATVL_existing_description = NULL;

        SELECT
            @PATVL_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_id';


        IF @PATVL_existing_description = @PATVL_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PATVL_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PATVL_id';
            PRINT N'            Expected                     : '
                + @PATVL_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PATVL_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PATVL_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PATVL_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PATVL_PAT_id
    ----------------------------------------------------------------------*/

    SET @PATVL_expected_description =
        N'Foreign key of catalog.ProductAttribute.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_PAT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PATVL_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttributeValue',
            @level2type = N'COLUMN',
            @level2name = N'PATVL_PAT_id';

        PRINT N'        [+] Column description added      : PATVL_PAT_id';

    END
    ELSE
    BEGIN

        SET @PATVL_existing_description = NULL;

        SELECT
            @PATVL_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_PAT_id';


        IF @PATVL_existing_description = @PATVL_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PATVL_PAT_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PATVL_PAT_id';
            PRINT N'            Expected                     : '
                + @PATVL_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PATVL_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PATVL_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PATVL_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PATVL_value
    ----------------------------------------------------------------------*/

    SET @PATVL_expected_description =
        N'Stores the value used to identify a valid option for the associated product attribute.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_value'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PATVL_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttributeValue',
            @level2type = N'COLUMN',
            @level2name = N'PATVL_value';

        PRINT N'        [+] Column description added      : PATVL_value';

    END
    ELSE
    BEGIN

        SET @PATVL_existing_description = NULL;

        SELECT
            @PATVL_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_value';


        IF @PATVL_existing_description = @PATVL_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PATVL_value';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PATVL_value';
            PRINT N'            Expected                     : '
                + @PATVL_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PATVL_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PATVL_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PATVL_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PATVL_is_active
    ----------------------------------------------------------------------*/

    SET @PATVL_expected_description =
        N'Indicates whether the product attribute value is currently available for use in catalog operations while preserving inactive values for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PATVL_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttributeValue',
            @level2type = N'COLUMN',
            @level2name = N'PATVL_is_active';

        PRINT N'        [+] Column description added      : PATVL_is_active';

    END
    ELSE
    BEGIN

        SET @PATVL_existing_description = NULL;

        SELECT
            @PATVL_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_is_active';


        IF @PATVL_existing_description = @PATVL_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PATVL_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PATVL_is_active';
            PRINT N'            Expected                     : '
                + @PATVL_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PATVL_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PATVL_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PATVL_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PATVL_created_at
    ----------------------------------------------------------------------*/

    SET @PATVL_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PATVL_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttributeValue',
            @level2type = N'COLUMN',
            @level2name = N'PATVL_created_at';

        PRINT N'        [+] Column description added      : PATVL_created_at';

    END
    ELSE
    BEGIN

        SET @PATVL_existing_description = NULL;

        SELECT
            @PATVL_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_created_at';


        IF @PATVL_existing_description = @PATVL_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PATVL_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PATVL_created_at';
            PRINT N'            Expected                     : '
                + @PATVL_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PATVL_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PATVL_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PATVL_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PATVL_updated_at
    ----------------------------------------------------------------------*/

    SET @PATVL_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PATVL_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttributeValue',
            @level2type = N'COLUMN',
            @level2name = N'PATVL_updated_at';

        PRINT N'        [+] Column description added      : PATVL_updated_at';

    END
    ELSE
    BEGIN

        SET @PATVL_existing_description = NULL;

        SELECT
            @PATVL_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PATVL_updated_at';


        IF @PATVL_existing_description = @PATVL_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PATVL_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PATVL_updated_at';
            PRINT N'            Expected                     : '
                + @PATVL_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PATVL_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PATVL_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PATVL_existing_description
                END;

        END;

    END;


    PRINT N'';