    PRINT N'';
    PRINT N'    ● catalog.ProductVariant';
    PRINT N'';

    DECLARE @PRDVA_expected_description nvarchar(4000);
    DECLARE @PRDVA_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PRDVA_expected_description =
        N'Maintains the sellable variants associated with products in the Atlas Commerce catalog.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVA_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariant';

        PRINT N'        [+] Table description added       : catalog.ProductVariant';

    END
    ELSE
    BEGIN

        SET @PRDVA_existing_description = NULL;


        SELECT
            @PRDVA_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PRDVA_existing_description =
            @PRDVA_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.ProductVariant';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.ProductVariant';
            PRINT N'            Expected                     : '
                + @PRDVA_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVA_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVA_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVA_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVA_id
    ----------------------------------------------------------------------*/

    SET @PRDVA_expected_description =
        N'Primary key of catalog.ProductVariant.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVA_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariant',
            @level2type = N'COLUMN',
            @level2name = N'PRDVA_id';

        PRINT N'        [+] Column description added      : PRDVA_id';

    END
    ELSE
    BEGIN

        SET @PRDVA_existing_description = NULL;


        SELECT
            @PRDVA_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_id';


        IF @PRDVA_existing_description =
            @PRDVA_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVA_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVA_id';
            PRINT N'            Expected                     : '
                + @PRDVA_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVA_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVA_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVA_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVA_PRD_id
    ----------------------------------------------------------------------*/

    SET @PRDVA_expected_description =
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
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_PRD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVA_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariant',
            @level2type = N'COLUMN',
            @level2name = N'PRDVA_PRD_id';

        PRINT N'        [+] Column description added      : PRDVA_PRD_id';

    END
    ELSE
    BEGIN

        SET @PRDVA_existing_description = NULL;


        SELECT
            @PRDVA_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_PRD_id';


        IF @PRDVA_existing_description =
            @PRDVA_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVA_PRD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVA_PRD_id';
            PRINT N'            Expected                     : '
                + @PRDVA_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVA_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVA_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVA_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVA_sku
    ----------------------------------------------------------------------*/

    SET @PRDVA_expected_description =
        N'Stores the stock keeping unit (SKU) used to uniquely identify the sellable product variant.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_sku'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVA_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariant',
            @level2type = N'COLUMN',
            @level2name = N'PRDVA_sku';

        PRINT N'        [+] Column description added      : PRDVA_sku';

    END
    ELSE
    BEGIN

        SET @PRDVA_existing_description = NULL;


        SELECT
            @PRDVA_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_sku';


        IF @PRDVA_existing_description =
            @PRDVA_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVA_sku';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVA_sku';
            PRINT N'            Expected                     : '
                + @PRDVA_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVA_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVA_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVA_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVA_barcode
    ----------------------------------------------------------------------*/

    SET @PRDVA_expected_description =
        N'Stores the optional barcode associated with the sellable product variant.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_barcode'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVA_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariant',
            @level2type = N'COLUMN',
            @level2name = N'PRDVA_barcode';

        PRINT N'        [+] Column description added      : PRDVA_barcode';

    END
    ELSE
    BEGIN

        SET @PRDVA_existing_description = NULL;


        SELECT
            @PRDVA_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_barcode';


        IF @PRDVA_existing_description =
            @PRDVA_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVA_barcode';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVA_barcode';
            PRINT N'            Expected                     : '
                + @PRDVA_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVA_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVA_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVA_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVA_is_active
    ----------------------------------------------------------------------*/

    SET @PRDVA_expected_description =
        N'Indicates whether the product variant is currently available for use in catalog operations while preserving inactive variants for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVA_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariant',
            @level2type = N'COLUMN',
            @level2name = N'PRDVA_is_active';

        PRINT N'        [+] Column description added      : PRDVA_is_active';

    END
    ELSE
    BEGIN

        SET @PRDVA_existing_description = NULL;


        SELECT
            @PRDVA_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_is_active';


        IF @PRDVA_existing_description =
            @PRDVA_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVA_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVA_is_active';
            PRINT N'            Expected                     : '
                + @PRDVA_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVA_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVA_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVA_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVA_created_at
    ----------------------------------------------------------------------*/

    SET @PRDVA_expected_description =
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
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVA_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariant',
            @level2type = N'COLUMN',
            @level2name = N'PRDVA_created_at';

        PRINT N'        [+] Column description added      : PRDVA_created_at';

    END
    ELSE
    BEGIN

        SET @PRDVA_existing_description = NULL;


        SELECT
            @PRDVA_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_created_at';


        IF @PRDVA_existing_description =
            @PRDVA_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVA_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVA_created_at';
            PRINT N'            Expected                     : '
                + @PRDVA_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVA_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVA_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVA_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVA_updated_at
    ----------------------------------------------------------------------*/

    SET @PRDVA_expected_description =
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
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVA_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariant',
            @level2type = N'COLUMN',
            @level2name = N'PRDVA_updated_at';

        PRINT N'        [+] Column description added      : PRDVA_updated_at';

    END
    ELSE
    BEGIN

        SET @PRDVA_existing_description = NULL;


        SELECT
            @PRDVA_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVA_updated_at';


        IF @PRDVA_existing_description =
            @PRDVA_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVA_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVA_updated_at';
            PRINT N'            Expected                     : '
                + @PRDVA_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVA_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVA_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVA_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';