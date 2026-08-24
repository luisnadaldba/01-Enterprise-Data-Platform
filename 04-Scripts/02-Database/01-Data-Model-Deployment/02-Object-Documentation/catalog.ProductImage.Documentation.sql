    PRINT N'';
    PRINT N'    ● catalog.ProductImage';
    PRINT N'';

    DECLARE @PRDIM_expected_description nvarchar(4000);
    DECLARE @PRDIM_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
        N'Maintains references and presentation metadata for images associated with products in the Atlas Commerce catalog while keeping binary image content outside the relational database.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage';

        PRINT N'        [+] Table description added       : catalog.ProductImage';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.ProductImage';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.ProductImage';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDIM_id
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
        N'Primary key of catalog.ProductImage.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage',
            @level2type = N'COLUMN',
            @level2name = N'PRDIM_id';

        PRINT N'        [+] Column description added      : PRDIM_id';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_id';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDIM_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDIM_id';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDIM_PRD_id
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
        N'Foreign key referencing catalog.Product.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_PRD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage',
            @level2type = N'COLUMN',
            @level2name = N'PRDIM_PRD_id';

        PRINT N'        [+] Column description added      : PRDIM_PRD_id';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_PRD_id';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDIM_PRD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDIM_PRD_id';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDIM_path
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
        N'Stores the external path or object reference used to locate the product image while keeping binary image content outside the relational database.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_path'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage',
            @level2type = N'COLUMN',
            @level2name = N'PRDIM_path';

        PRINT N'        [+] Column description added      : PRDIM_path';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_path';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDIM_path';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDIM_path';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDIM_display_order
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
        N'Defines the presentation sequence of the image within the collection of images associated with the product.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_display_order'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage',
            @level2type = N'COLUMN',
            @level2name = N'PRDIM_display_order';

        PRINT N'        [+] Column description added      : PRDIM_display_order';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_display_order';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDIM_display_order';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDIM_display_order';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDIM_is_primary
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
        N'Indicates whether the image is the primary image used to represent the product in catalog presentation.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_is_primary'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage',
            @level2type = N'COLUMN',
            @level2name = N'PRDIM_is_primary';

        PRINT N'        [+] Column description added      : PRDIM_is_primary';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_is_primary';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDIM_is_primary';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDIM_is_primary';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDIM_is_active
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
        N'Indicates whether the image is currently available for use in catalog presentation while preserving inactive image records for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage',
            @level2type = N'COLUMN',
            @level2name = N'PRDIM_is_active';

        PRINT N'        [+] Column description added      : PRDIM_is_active';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_is_active';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDIM_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDIM_is_active';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDIM_created_at
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
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
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage',
            @level2type = N'COLUMN',
            @level2name = N'PRDIM_created_at';

        PRINT N'        [+] Column description added      : PRDIM_created_at';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_created_at';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDIM_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDIM_created_at';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDIM_updated_at
    ----------------------------------------------------------------------*/

    SET @PRDIM_expected_description =
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
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDIM_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductImage',
            @level2type = N'COLUMN',
            @level2name = N'PRDIM_updated_at';

        PRINT N'        [+] Column description added      : PRDIM_updated_at';

    END
    ELSE
    BEGIN

        SET @PRDIM_existing_description = NULL;


        SELECT
            @PRDIM_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDIM_updated_at';


        IF @PRDIM_existing_description =
            @PRDIM_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDIM_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDIM_updated_at';
            PRINT N'            Expected                     : '
                + @PRDIM_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDIM_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDIM_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDIM_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';