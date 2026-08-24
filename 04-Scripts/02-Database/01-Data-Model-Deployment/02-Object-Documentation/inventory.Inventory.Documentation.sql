    PRINT N'';
    PRINT N'    ● inventory.Inventory';
    PRINT N'';

    DECLARE @INV_expected_description nvarchar(4000);
    DECLARE @INV_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @INV_expected_description =
        N'Maintains the current usable and reserved inventory quantities for each product variant in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'Inventory';

        PRINT N'        [+] Table description added       : inventory.Inventory';

    END
    ELSE
    BEGIN

        SET @INV_existing_description = NULL;


        SELECT
            @INV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @INV_existing_description =
            @INV_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : inventory.Inventory';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : inventory.Inventory';
            PRINT N'            Expected                     : '
                + @INV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INV_id
    ----------------------------------------------------------------------*/

    SET @INV_expected_description =
        N'Primary key of inventory.Inventory.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'Inventory',
            @level2type = N'COLUMN',
            @level2name = N'INV_id';

        PRINT N'        [+] Column description added      : INV_id';

    END
    ELSE
    BEGIN

        SET @INV_existing_description = NULL;


        SELECT
            @INV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_id';


        IF @INV_existing_description =
            @INV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INV_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INV_id';
            PRINT N'            Expected                     : '
                + @INV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INV_PRDVA_id
    ----------------------------------------------------------------------*/

    SET @INV_expected_description =
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
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_PRDVA_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'Inventory',
            @level2type = N'COLUMN',
            @level2name = N'INV_PRDVA_id';

        PRINT N'        [+] Column description added      : INV_PRDVA_id';

    END
    ELSE
    BEGIN

        SET @INV_existing_description = NULL;


        SELECT
            @INV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_PRDVA_id';


        IF @INV_existing_description =
            @INV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INV_PRDVA_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INV_PRDVA_id';
            PRINT N'            Expected                     : '
                + @INV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INV_quantity_on_hand
    ----------------------------------------------------------------------*/

    SET @INV_expected_description =
        N'Stores the current quantity of usable units physically available in inventory for the product variant.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_quantity_on_hand'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'Inventory',
            @level2type = N'COLUMN',
            @level2name = N'INV_quantity_on_hand';

        PRINT N'        [+] Column description added      : INV_quantity_on_hand';

    END
    ELSE
    BEGIN

        SET @INV_existing_description = NULL;


        SELECT
            @INV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_quantity_on_hand';


        IF @INV_existing_description =
            @INV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INV_quantity_on_hand';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INV_quantity_on_hand';
            PRINT N'            Expected                     : '
                + @INV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INV_quantity_reserved
    ----------------------------------------------------------------------*/

    SET @INV_expected_description =
        N'Stores the quantity of usable inventory units already reserved and therefore unavailable for new sales.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_quantity_reserved'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'Inventory',
            @level2type = N'COLUMN',
            @level2name = N'INV_quantity_reserved';

        PRINT N'        [+] Column description added      : INV_quantity_reserved';

    END
    ELSE
    BEGIN

        SET @INV_existing_description = NULL;


        SELECT
            @INV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_quantity_reserved';


        IF @INV_existing_description =
            @INV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INV_quantity_reserved';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INV_quantity_reserved';
            PRINT N'            Expected                     : '
                + @INV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INV_created_at
    ----------------------------------------------------------------------*/

    SET @INV_expected_description =
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
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'Inventory',
            @level2type = N'COLUMN',
            @level2name = N'INV_created_at';

        PRINT N'        [+] Column description added      : INV_created_at';

    END
    ELSE
    BEGIN

        SET @INV_existing_description = NULL;


        SELECT
            @INV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_created_at';


        IF @INV_existing_description =
            @INV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INV_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INV_created_at';
            PRINT N'            Expected                     : '
                + @INV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INV_updated_at
    ----------------------------------------------------------------------*/

    SET @INV_expected_description =
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
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'Inventory',
            @level2type = N'COLUMN',
            @level2name = N'INV_updated_at';

        PRINT N'        [+] Column description added      : INV_updated_at';

    END
    ELSE
    BEGIN

        SET @INV_existing_description = NULL;


        SELECT
            @INV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.Inventory')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INV_updated_at';


        IF @INV_existing_description =
            @INV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INV_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INV_updated_at';
            PRINT N'            Expected                     : '
                + @INV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INV_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';