    PRINT N'    catalog.ProductAttribute';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @PAT_expected_description nvarchar(4000);
    DECLARE @PAT_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PAT_expected_description =
        N'Maintains the controlled set of reusable product attributes used to describe characteristics of products and their sellable variants.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttribute';

        PRINT N'        [+] Table description added       : catalog.ProductAttribute';

    END
    ELSE
    BEGIN

        SET @PAT_existing_description = NULL;

        SELECT
            @PAT_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @PAT_existing_description = @PAT_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.ProductAttribute';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.ProductAttribute';
            PRINT N'            Expected                     : '
                + @PAT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PAT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PAT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAT_id
    ----------------------------------------------------------------------*/

    SET @PAT_expected_description =
        N'Primary key of catalog.ProductAttribute.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttribute',
            @level2type = N'COLUMN',
            @level2name = N'PAT_id';

        PRINT N'        [+] Column description added      : PAT_id';

    END
    ELSE
    BEGIN

        SET @PAT_existing_description = NULL;

        SELECT
            @PAT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_id';

        IF @PAT_existing_description = @PAT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAT_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAT_id';
            PRINT N'            Expected                     : '
                + @PAT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAT_name
    ----------------------------------------------------------------------*/

    SET @PAT_expected_description =
        N'Stores the name used to identify the product attribute in the catalog.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttribute',
            @level2type = N'COLUMN',
            @level2name = N'PAT_name';

        PRINT N'        [+] Column description added      : PAT_name';

    END
    ELSE
    BEGIN

        SET @PAT_existing_description = NULL;

        SELECT
            @PAT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_name';

        IF @PAT_existing_description = @PAT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAT_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAT_name';
            PRINT N'            Expected                     : '
                + @PAT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAT_is_active
    ----------------------------------------------------------------------*/

    SET @PAT_expected_description =
        N'Indicates whether the product attribute is currently available for use in catalog operations while preserving inactive attributes for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttribute',
            @level2type = N'COLUMN',
            @level2name = N'PAT_is_active';

        PRINT N'        [+] Column description added      : PAT_is_active';

    END
    ELSE
    BEGIN

        SET @PAT_existing_description = NULL;

        SELECT
            @PAT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_is_active';

        IF @PAT_existing_description = @PAT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAT_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAT_is_active';
            PRINT N'            Expected                     : '
                + @PAT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAT_created_at
    ----------------------------------------------------------------------*/

    SET @PAT_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttribute',
            @level2type = N'COLUMN',
            @level2name = N'PAT_created_at';

        PRINT N'        [+] Column description added      : PAT_created_at';

    END
    ELSE
    BEGIN

        SET @PAT_existing_description = NULL;

        SELECT
            @PAT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_created_at';

        IF @PAT_existing_description = @PAT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAT_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAT_created_at';
            PRINT N'            Expected                     : '
                + @PAT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PAT_updated_at
    ----------------------------------------------------------------------*/

    SET @PAT_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PAT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductAttribute',
            @level2type = N'COLUMN',
            @level2name = N'PAT_updated_at';

        PRINT N'        [+] Column description added      : PAT_updated_at';

    END
    ELSE
    BEGIN

        SET @PAT_existing_description = NULL;

        SELECT
            @PAT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductAttribute')
        AND ep.name = N'MS_Description'
        AND c.name = N'PAT_updated_at';

        IF @PAT_existing_description = @PAT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PAT_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PAT_updated_at';
            PRINT N'            Expected                     : '
                + @PAT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PAT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@PAT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @PAT_existing_description
                END;

        END;

    END;


    PRINT N'';