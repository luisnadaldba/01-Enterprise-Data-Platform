PRINT N'    sales.Transaction';
PRINT N'    --------------------------------------------------------------------------';

DECLARE @TRN_expected_description nvarchar(4000);
DECLARE @TRN_existing_description nvarchar(4000);


/*----------------------------------------------------------------------
    TABLE DESCRIPTION
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Stores the core sales transaction record.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.minor_id = 0
      AND ep.name = N'MS_Description'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction';

    PRINT N'        [+] Table description added       : sales.Transaction';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.minor_id = 0
      AND ep.name = N'MS_Description';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Table description validated   : sales.Transaction';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Table description mismatch    : sales.Transaction';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL
                    THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0
                    THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_id
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Primary key of sales.Transaction.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_id'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_id';

    PRINT N'        [+] Column description added      : TRN_id';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_id';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_id';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_id';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_transaction_at
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Records the date and time when the transaction occurred.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_transaction_at'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_transaction_at';

    PRINT N'        [+] Column description added      : TRN_transaction_at';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_transaction_at';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_transaction_at';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_transaction_at';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_CST_id
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Foreign key of customer.Customer.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_CST_id'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_CST_id';

    PRINT N'        [+] Column description added      : TRN_CST_id';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_CST_id';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_CST_id';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_CST_id';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_TRNST_id
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Foreign key of sales.TransactionStatus.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_TRNST_id'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_TRNST_id';

    PRINT N'        [+] Column description added      : TRN_TRNST_id';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_TRNST_id';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_TRNST_id';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_TRNST_id';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_TRNCH_id
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Foreign key of sales.TransactionChannel.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_TRNCH_id'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_TRNCH_id';

    PRINT N'        [+] Column description added      : TRN_TRNCH_id';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_TRNCH_id';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_TRNCH_id';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_TRNCH_id';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_gross_amount
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Gross amount of the transaction before discounts.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_gross_amount'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_gross_amount';

    PRINT N'        [+] Column description added      : TRN_gross_amount';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_gross_amount';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_gross_amount';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_gross_amount';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_discount_amount
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Total discount amount applied to the transaction.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_discount_amount'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_discount_amount';

    PRINT N'        [+] Column description added      : TRN_discount_amount';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_discount_amount';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_discount_amount';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_discount_amount';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_shipping_amount
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Shipping amount charged for the transaction.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_shipping_amount'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_shipping_amount';

    PRINT N'        [+] Column description added      : TRN_shipping_amount';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_shipping_amount';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_shipping_amount';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_shipping_amount';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_created_at
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Records the date and time when the row was initially created.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_created_at'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_created_at';

    PRINT N'        [+] Column description added      : TRN_created_at';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_created_at';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_created_at';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_created_at';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;


/*----------------------------------------------------------------------
    COLUMN DESCRIPTION: TRN_updated_at
----------------------------------------------------------------------*/

SET @TRN_expected_description =
    N'Records the date and time of the most recent meaningful modification to the row.';

IF NOT EXISTS
(
    SELECT 1
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_updated_at'
)
BEGIN
    EXEC sys.sp_addextendedproperty
        @name = N'MS_Description',
        @value = @TRN_expected_description,
        @level0type = N'SCHEMA',
        @level0name = N'sales',
        @level1type = N'TABLE',
        @level1name = N'Transaction',
        @level2type = N'COLUMN',
        @level2name = N'TRN_updated_at';

    PRINT N'        [+] Column description added      : TRN_updated_at';
END
ELSE
BEGIN
    SET @TRN_existing_description = NULL;

    SELECT
        @TRN_existing_description = CONVERT(nvarchar(4000), ep.value)
    FROM sys.extended_properties AS ep
    INNER JOIN sys.columns AS c
        ON  c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
    WHERE ep.class = 1
      AND ep.major_id = OBJECT_ID(N'sales.[Transaction]')
      AND ep.name = N'MS_Description'
      AND c.name = N'TRN_updated_at';

    IF @TRN_existing_description = @TRN_expected_description
    BEGIN
        PRINT N'        [•] Column description validated  : TRN_updated_at';
    END
    ELSE
    BEGIN
        PRINT N'        [!] Column description mismatch   : TRN_updated_at';
        PRINT N'            Expected                     : ' + @TRN_expected_description;
        PRINT N'            Actual                       : '
            + CASE
                WHEN @TRN_existing_description IS NULL THEN N'<NULL>'
                WHEN LEN(@TRN_existing_description) = 0 THEN N'<EMPTY>'
                ELSE @TRN_existing_description
              END;
    END;
END;

PRINT N'';