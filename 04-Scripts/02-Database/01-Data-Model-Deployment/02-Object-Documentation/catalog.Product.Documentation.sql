    PRINT N'';
    PRINT N'    ● catalog.Product';
    PRINT N'';

    DECLARE @PRD_expected_description nvarchar(4000);
    DECLARE @PRD_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PRD_expected_description =
        N'Maintains the commercial identity of products available in the Atlas Commerce catalog independently from their sellable variants.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Product';

        PRINT N'        [+] Table description added       : catalog.Product';

    END
    ELSE
    BEGIN

        SET @PRD_existing_description = NULL;


        SELECT
            @PRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PRD_existing_description =
            @PRD_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.Product';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.Product';
            PRINT N'            Expected                     : '
                + @PRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRD_id
    ----------------------------------------------------------------------*/

    SET @PRD_expected_description =
        N'Primary key of catalog.Product.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Product',
            @level2type = N'COLUMN',
            @level2name = N'PRD_id';

        PRINT N'        [+] Column description added      : PRD_id';

    END
    ELSE
    BEGIN

        SET @PRD_existing_description = NULL;


        SELECT
            @PRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_id';


        IF @PRD_existing_description =
            @PRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRD_id';
            PRINT N'            Expected                     : '
                + @PRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRD_BRD_id
    ----------------------------------------------------------------------*/

    SET @PRD_expected_description =
        N'Foreign key referencing catalog.Brand.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_BRD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Product',
            @level2type = N'COLUMN',
            @level2name = N'PRD_BRD_id';

        PRINT N'        [+] Column description added      : PRD_BRD_id';

    END
    ELSE
    BEGIN

        SET @PRD_existing_description = NULL;


        SELECT
            @PRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_BRD_id';


        IF @PRD_existing_description =
            @PRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRD_BRD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRD_BRD_id';
            PRINT N'            Expected                     : '
                + @PRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRD_name
    ----------------------------------------------------------------------*/

    SET @PRD_expected_description =
        N'Stores the commercial name used to identify the product in the catalog.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Product',
            @level2type = N'COLUMN',
            @level2name = N'PRD_name';

        PRINT N'        [+] Column description added      : PRD_name';

    END
    ELSE
    BEGIN

        SET @PRD_existing_description = NULL;


        SELECT
            @PRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_name';


        IF @PRD_existing_description =
            @PRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRD_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRD_name';
            PRINT N'            Expected                     : '
                + @PRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRD_is_active
    ----------------------------------------------------------------------*/

    SET @PRD_expected_description =
        N'Indicates whether the product is currently available for use in catalog operations while preserving inactive products for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Product',
            @level2type = N'COLUMN',
            @level2name = N'PRD_is_active';

        PRINT N'        [+] Column description added      : PRD_is_active';

    END
    ELSE
    BEGIN

        SET @PRD_existing_description = NULL;


        SELECT
            @PRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_is_active';


        IF @PRD_existing_description =
            @PRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRD_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRD_is_active';
            PRINT N'            Expected                     : '
                + @PRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRD_created_at
    ----------------------------------------------------------------------*/

    SET @PRD_expected_description =
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
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Product',
            @level2type = N'COLUMN',
            @level2name = N'PRD_created_at';

        PRINT N'        [+] Column description added      : PRD_created_at';

    END
    ELSE
    BEGIN

        SET @PRD_existing_description = NULL;


        SELECT
            @PRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_created_at';


        IF @PRD_existing_description =
            @PRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRD_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRD_created_at';
            PRINT N'            Expected                     : '
                + @PRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRD_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRD_updated_at
    ----------------------------------------------------------------------*/

    SET @PRD_expected_description =
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
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Product',
            @level2type = N'COLUMN',
            @level2name = N'PRD_updated_at';

        PRINT N'        [+] Column description added      : PRD_updated_at';

    END
    ELSE
    BEGIN

        SET @PRD_existing_description = NULL;


        SELECT
            @PRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.Product')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRD_updated_at';


        IF @PRD_existing_description =
            @PRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRD_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRD_updated_at';
            PRINT N'            Expected                     : '
                + @PRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRD_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';