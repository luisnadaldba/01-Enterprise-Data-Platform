    PRINT N'';
    PRINT N'    ● catalog.ProductCategory';
    PRINT N'';

    DECLARE @PRDCT_expected_description nvarchar(4000);
    DECLARE @PRDCT_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PRDCT_expected_description =
        N'Associates products with the catalog categories in which they are classified.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductCategory';

        PRINT N'        [+] Table description added       : catalog.ProductCategory';

    END
    ELSE
    BEGIN

        SET @PRDCT_existing_description = NULL;


        SELECT
            @PRDCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PRDCT_existing_description =
            @PRDCT_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.ProductCategory';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.ProductCategory';
            PRINT N'            Expected                     : '
                + @PRDCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDCT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDCT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDCT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDCT_PRD_id
    ----------------------------------------------------------------------*/

    SET @PRDCT_expected_description =
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
                OBJECT_ID(N'catalog.ProductCategory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDCT_PRD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductCategory',
            @level2type = N'COLUMN',
            @level2name = N'PRDCT_PRD_id';

        PRINT N'        [+] Column description added      : PRDCT_PRD_id';

    END
    ELSE
    BEGIN

        SET @PRDCT_existing_description = NULL;


        SELECT
            @PRDCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDCT_PRD_id';


        IF @PRDCT_existing_description =
            @PRDCT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDCT_PRD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDCT_PRD_id';
            PRINT N'            Expected                     : '
                + @PRDCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDCT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDCT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDCT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDCT_CTG_id
    ----------------------------------------------------------------------*/

    SET @PRDCT_expected_description =
        N'Foreign key referencing catalog.Category.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDCT_CTG_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDCT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductCategory',
            @level2type = N'COLUMN',
            @level2name = N'PRDCT_CTG_id';

        PRINT N'        [+] Column description added      : PRDCT_CTG_id';

    END
    ELSE
    BEGIN

        SET @PRDCT_existing_description = NULL;


        SELECT
            @PRDCT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PRDCT_CTG_id';


        IF @PRDCT_existing_description =
            @PRDCT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDCT_CTG_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDCT_CTG_id';
            PRINT N'            Expected                     : '
                + @PRDCT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDCT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDCT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDCT_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';