    PRINT N'    catalog.Category';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @CTG_expected_description nvarchar(4000);
    DECLARE @CTG_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CTG_expected_description =
        N'Maintains the hierarchical category structure used to organize products in the Atlas Commerce catalog.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTG_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Category';

        PRINT N'        [+] Table description added       : catalog.Category';

    END
    ELSE
    BEGIN

        SET @CTG_existing_description = NULL;

        SELECT
            @CTG_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @CTG_existing_description = @CTG_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.Category';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.Category';
            PRINT N'            Expected                     : '
                + @CTG_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTG_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTG_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTG_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTG_id
    ----------------------------------------------------------------------*/

    SET @CTG_expected_description =
        N'Primary key of catalog.Category.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTG_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Category',
            @level2type = N'COLUMN',
            @level2name = N'CTG_id';

        PRINT N'        [+] Column description added      : CTG_id';

    END
    ELSE
    BEGIN

        SET @CTG_existing_description = NULL;

        SELECT
            @CTG_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_id';

        IF @CTG_existing_description = @CTG_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTG_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTG_id';
            PRINT N'            Expected                     : '
                + @CTG_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTG_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTG_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTG_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTG_CTG_id
    ----------------------------------------------------------------------*/

    SET @CTG_expected_description =
        N'Identifies the parent category in the catalog hierarchy. NULL indicates a root category.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_CTG_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTG_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Category',
            @level2type = N'COLUMN',
            @level2name = N'CTG_CTG_id';

        PRINT N'        [+] Column description added      : CTG_CTG_id';

    END
    ELSE
    BEGIN

        SET @CTG_existing_description = NULL;

        SELECT
            @CTG_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_CTG_id';

        IF @CTG_existing_description = @CTG_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTG_CTG_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTG_CTG_id';
            PRINT N'            Expected                     : '
                + @CTG_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTG_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTG_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTG_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTG_name
    ----------------------------------------------------------------------*/

    SET @CTG_expected_description =
        N'Stores the business name used to identify the category within the catalog hierarchy.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTG_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Category',
            @level2type = N'COLUMN',
            @level2name = N'CTG_name';

        PRINT N'        [+] Column description added      : CTG_name';

    END
    ELSE
    BEGIN

        SET @CTG_existing_description = NULL;

        SELECT
            @CTG_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_name';

        IF @CTG_existing_description = @CTG_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTG_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTG_name';
            PRINT N'            Expected                     : '
                + @CTG_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTG_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTG_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTG_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTG_is_active
    ----------------------------------------------------------------------*/

    SET @CTG_expected_description =
        N'Indicates whether the category is currently available for use in catalog operations while preserving inactive categories for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTG_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Category',
            @level2type = N'COLUMN',
            @level2name = N'CTG_is_active';

        PRINT N'        [+] Column description added      : CTG_is_active';

    END
    ELSE
    BEGIN

        SET @CTG_existing_description = NULL;

        SELECT
            @CTG_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_is_active';

        IF @CTG_existing_description = @CTG_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTG_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTG_is_active';
            PRINT N'            Expected                     : '
                + @CTG_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTG_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTG_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTG_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTG_created_at
    ----------------------------------------------------------------------*/

    SET @CTG_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTG_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Category',
            @level2type = N'COLUMN',
            @level2name = N'CTG_created_at';

        PRINT N'        [+] Column description added      : CTG_created_at';

    END
    ELSE
    BEGIN

        SET @CTG_existing_description = NULL;

        SELECT
            @CTG_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_created_at';

        IF @CTG_existing_description = @CTG_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTG_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTG_created_at';
            PRINT N'            Expected                     : '
                + @CTG_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTG_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTG_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTG_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTG_updated_at
    ----------------------------------------------------------------------*/

    SET @CTG_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTG_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Category',
            @level2type = N'COLUMN',
            @level2name = N'CTG_updated_at';

        PRINT N'        [+] Column description added      : CTG_updated_at';

    END
    ELSE
    BEGIN

        SET @CTG_existing_description = NULL;

        SELECT
            @CTG_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Category')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTG_updated_at';

        IF @CTG_existing_description = @CTG_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTG_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTG_updated_at';
            PRINT N'            Expected                     : '
                + @CTG_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTG_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTG_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTG_existing_description
                END;

        END;

    END;


    PRINT N'';