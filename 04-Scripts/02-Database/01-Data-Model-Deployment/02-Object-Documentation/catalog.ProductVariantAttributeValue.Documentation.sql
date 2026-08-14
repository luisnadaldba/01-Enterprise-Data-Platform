    PRINT N'    catalog.ProductVariantAttributeValue';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @PRDAV_expected_description nvarchar(4000);
    DECLARE @PRDAV_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PRDAV_expected_description =
        N'Associates sellable product variants with the controlled product attribute values that define their catalog characteristics.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductVariantAttributeValue')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDAV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantAttributeValue';

        PRINT N'        [+] Table description added       : catalog.ProductVariantAttributeValue';

    END
    ELSE
    BEGIN

        SET @PRDAV_existing_description = NULL;

        SELECT
            @PRDAV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.ProductVariantAttributeValue')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';


        IF @PRDAV_existing_description =
            @PRDAV_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.ProductVariantAttributeValue';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.ProductVariantAttributeValue';
            PRINT N'            Expected                     : '
                + @PRDAV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDAV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDAV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDAV_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDAV_PRDVA_id
    ----------------------------------------------------------------------*/

    SET @PRDAV_expected_description =
        N'Foreign key of catalog.ProductVariant.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PRDAV_PRDVA_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDAV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantAttributeValue',
            @level2type = N'COLUMN',
            @level2name = N'PRDAV_PRDVA_id';

        PRINT N'        [+] Column description added      : PRDAV_PRDVA_id';

    END
    ELSE
    BEGIN

        SET @PRDAV_existing_description = NULL;

        SELECT
            @PRDAV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PRDAV_PRDVA_id';


        IF @PRDAV_existing_description =
            @PRDAV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDAV_PRDVA_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDAV_PRDVA_id';
            PRINT N'            Expected                     : '
                + @PRDAV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDAV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDAV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDAV_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PRDAV_PATVL_id
    ----------------------------------------------------------------------*/

    SET @PRDAV_expected_description =
        N'Foreign key of catalog.ProductAttributeValue.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PRDAV_PATVL_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PRDAV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'ProductVariantAttributeValue',
            @level2type = N'COLUMN',
            @level2name = N'PRDAV_PATVL_id';

        PRINT N'        [+] Column description added      : PRDAV_PATVL_id';

    END
    ELSE
    BEGIN

        SET @PRDAV_existing_description = NULL;

        SELECT
            @PRDAV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')
        AND ep.name = N'MS_Description'
        AND c.name = N'PRDAV_PATVL_id';


        IF @PRDAV_existing_description =
            @PRDAV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PRDAV_PATVL_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PRDAV_PATVL_id';
            PRINT N'            Expected                     : '
                + @PRDAV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PRDAV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PRDAV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PRDAV_existing_description
                END;

        END;

    END;


    PRINT N'';