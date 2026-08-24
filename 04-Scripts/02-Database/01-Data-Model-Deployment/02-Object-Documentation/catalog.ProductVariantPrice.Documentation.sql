    PRINT N'';
    PRINT N'    ● catalog.ProductVariantPrice';
    PRINT N'';

    DECLARE @PRDVP_expected_description nvarchar(4000);
    DECLARE @PRDVP_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PRDVP_expected_description =
        N'Maintains the price history and temporal validity of sellable product variants in the Atlas Commerce catalog without overwriting prior commercial prices.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantPrice';

        PRINT N'        [+] Table description added       : catalog.ProductVariantPrice';

    END
    ELSE
    BEGIN

        SET @PRDVP_existing_description = NULL;


        SELECT
            @PRDVP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PRDVP_existing_description =
            @PRDVP_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.ProductVariantPrice';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.ProductVariantPrice';
            PRINT N'            Expected                     : '
                + @PRDVP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVP_id
    ----------------------------------------------------------------------*/

    SET @PRDVP_expected_description =
        N'Primary key of catalog.ProductVariantPrice.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantPrice',
            @level2type = N'COLUMN',
            @level2name = N'PRDVP_id';

        PRINT N'        [+] Column description added      : PRDVP_id';

    END
    ELSE
    BEGIN

        SET @PRDVP_existing_description = NULL;


        SELECT
            @PRDVP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_id';


        IF @PRDVP_existing_description =
            @PRDVP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVP_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVP_id';
            PRINT N'            Expected                     : '
                + @PRDVP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVP_PRDVA_id
    ----------------------------------------------------------------------*/

    SET @PRDVP_expected_description =
        N'Foreign key referencing catalog.ProductVariant.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_PRDVA_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantPrice',
            @level2type = N'COLUMN',
            @level2name = N'PRDVP_PRDVA_id';

        PRINT N'        [+] Column description added      : PRDVP_PRDVA_id';

    END
    ELSE
    BEGIN

        SET @PRDVP_existing_description = NULL;


        SELECT
            @PRDVP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_PRDVA_id';


        IF @PRDVP_existing_description =
            @PRDVP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVP_PRDVA_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVP_PRDVA_id';
            PRINT N'            Expected                     : '
                + @PRDVP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVP_price
    ----------------------------------------------------------------------*/

    SET @PRDVP_expected_description =
        N'Stores the commercial price applicable to the product variant during the validity interval represented by the row.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_price'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantPrice',
            @level2type = N'COLUMN',
            @level2name = N'PRDVP_price';

        PRINT N'        [+] Column description added      : PRDVP_price';

    END
    ELSE
    BEGIN

        SET @PRDVP_existing_description = NULL;


        SELECT
            @PRDVP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_price';


        IF @PRDVP_existing_description =
            @PRDVP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVP_price';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVP_price';
            PRINT N'            Expected                     : '
                + @PRDVP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVP_valid_from
    ----------------------------------------------------------------------*/

    SET @PRDVP_expected_description =
        N'Defines the inclusive lower boundary of the period during which the price becomes applicable to the product variant.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_valid_from'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantPrice',
            @level2type = N'COLUMN',
            @level2name = N'PRDVP_valid_from';

        PRINT N'        [+] Column description added      : PRDVP_valid_from';

    END
    ELSE
    BEGIN

        SET @PRDVP_existing_description = NULL;


        SELECT
            @PRDVP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_valid_from';


        IF @PRDVP_existing_description =
            @PRDVP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVP_valid_from';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVP_valid_from';
            PRINT N'            Expected                     : '
                + @PRDVP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVP_valid_to
    ----------------------------------------------------------------------*/

    SET @PRDVP_expected_description =
        N'Defines the exclusive upper boundary of the price validity interval. NULL represents an open-ended period with no defined end date.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_valid_to'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantPrice',
            @level2type = N'COLUMN',
            @level2name = N'PRDVP_valid_to';

        PRINT N'        [+] Column description added      : PRDVP_valid_to';

    END
    ELSE
    BEGIN

        SET @PRDVP_existing_description = NULL;


        SELECT
            @PRDVP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_valid_to';


        IF @PRDVP_existing_description =
            @PRDVP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVP_valid_to';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVP_valid_to';
            PRINT N'            Expected                     : '
                + @PRDVP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDVP_created_at
    ----------------------------------------------------------------------*/

    SET @PRDVP_expected_description =
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
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDVP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantPrice',
            @level2type = N'COLUMN',
            @level2name = N'PRDVP_created_at';

        PRINT N'        [+] Column description added      : PRDVP_created_at';

    END
    ELSE
    BEGIN

        SET @PRDVP_existing_description = NULL;


        SELECT
            @PRDVP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDVP_created_at';


        IF @PRDVP_existing_description =
            @PRDVP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDVP_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDVP_created_at';
            PRINT N'            Expected                     : '
                + @PRDVP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDVP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDVP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDVP_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';