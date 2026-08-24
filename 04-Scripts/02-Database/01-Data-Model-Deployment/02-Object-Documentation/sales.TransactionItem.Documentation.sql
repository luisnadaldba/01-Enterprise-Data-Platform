    PRINT N'';
    PRINT N'    ● sales.TransactionItem';
    PRINT N'';


    DECLARE @TRNIT_expected_description nvarchar(4000);
    DECLARE @TRNIT_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
        N'Maintains the individual product items associated with sales transactions in Atlas Commerce, including product variant, quantity, unit price, unit discount, and the originating transaction timestamp.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem';

        PRINT N'        [+] Table description added       : sales.TransactionItem';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : sales.TransactionItem';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : sales.TransactionItem';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_id
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
        N'Primary key of sales.TransactionItem.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_id';

        PRINT N'        [+] Column description added      : TRNIT_id';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_id';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_id';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_transaction_at
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
        N'Records the date and time of the parent sales transaction and supports aligned partitioning with sales.Transaction.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_transaction_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_transaction_at';

        PRINT N'        [+] Column description added      : TRNIT_transaction_at';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_transaction_at';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_transaction_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_transaction_at';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_TRN_id
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
        N'Foreign key referencing sales.Transaction.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_TRN_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_TRN_id';

        PRINT N'        [+] Column description added      : TRNIT_TRN_id';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_TRN_id';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_TRN_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_TRN_id';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_PRDVA_id
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
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
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_PRDVA_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_PRDVA_id';

        PRINT N'        [+] Column description added      : TRNIT_PRDVA_id';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_PRDVA_id';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_PRDVA_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_PRDVA_id';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_quantity
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
        N'Stores the quantity of the product variant included in the transaction item.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_quantity'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_quantity';

        PRINT N'        [+] Column description added      : TRNIT_quantity';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_quantity';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_quantity';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_quantity';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_unit_price
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
        N'Stores the unit price of the product variant recorded for the transaction item.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_unit_price'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_unit_price';

        PRINT N'        [+] Column description added      : TRNIT_unit_price';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_unit_price';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_unit_price';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_unit_price';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_unit_discount
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
        N'Stores the unit discount applied to the product variant for the transaction item.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_unit_discount'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_unit_discount';

        PRINT N'        [+] Column description added      : TRNIT_unit_discount';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_unit_discount';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_unit_discount';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_unit_discount';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_created_at
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
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
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_created_at';

        PRINT N'        [+] Column description added      : TRNIT_created_at';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_created_at';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_created_at';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNIT_updated_at
    ----------------------------------------------------------------------*/

    SET @TRNIT_expected_description =
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
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNIT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionItem',
            @level2type = N'COLUMN',
            @level2name = N'TRNIT_updated_at';

        PRINT N'        [+] Column description added      : TRNIT_updated_at';

    END
    ELSE
    BEGIN

        SET @TRNIT_existing_description = NULL;


        SELECT
            @TRNIT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNIT_updated_at';


        IF @TRNIT_existing_description =
            @TRNIT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNIT_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNIT_updated_at';
            PRINT N'            Expected                     : '
                + @TRNIT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNIT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNIT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNIT_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';