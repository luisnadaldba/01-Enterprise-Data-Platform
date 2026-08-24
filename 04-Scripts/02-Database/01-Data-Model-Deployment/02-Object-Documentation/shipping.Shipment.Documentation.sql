    PRINT N'';
    PRINT N'    ● shipping.Shipment';
    PRINT N'';

    DECLARE @SHP_expected_description nvarchar(4000);
    DECLARE @SHP_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Records the delivery process associated with Atlas Commerce sales transactions that require shipment, including destination, shipment method, status, shipping amount, delivery estimate, tracking information, and relevant business-event timestamps.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment';

        PRINT N'        [+] Table description added       : shipping.Shipment';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : shipping.Shipment';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : shipping.Shipment';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_id
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Primary key of shipping.Shipment.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_id';

        PRINT N'        [+] Column description added      : SHP_id';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_id';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_id';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_TRN_id
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
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
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_TRN_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_TRN_id';

        PRINT N'        [+] Column description added      : SHP_TRN_id';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_TRN_id';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_TRN_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_TRN_id';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_transaction_at
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Records the date and time of the parent sales transaction and participates with SHP_TRN_id in the composite foreign key to sales.Transaction.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_transaction_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_transaction_at';

        PRINT N'        [+] Column description added      : SHP_transaction_at';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_transaction_at';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_transaction_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_transaction_at';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_CSTAD_id
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Foreign key referencing customer.CustomerAddress.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_CSTAD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_CSTAD_id';

        PRINT N'        [+] Column description added      : SHP_CSTAD_id';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_CSTAD_id';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_CSTAD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_CSTAD_id';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_SHPMT_id
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Foreign key referencing shipping.ShipmentMethod.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_SHPMT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_SHPMT_id';

        PRINT N'        [+] Column description added      : SHP_SHPMT_id';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_SHPMT_id';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_SHPMT_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_SHPMT_id';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_SHPST_id
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Foreign key referencing shipping.ShipmentStatus.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_SHPST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_SHPST_id';

        PRINT N'        [+] Column description added      : SHP_SHPST_id';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_SHPST_id';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_SHPST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_SHPST_id';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_shipping_amount
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Stores the shipping amount charged to the customer for this shipment.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_shipping_amount'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_shipping_amount';

        PRINT N'        [+] Column description added      : SHP_shipping_amount';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_shipping_amount';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_shipping_amount';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_shipping_amount';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_estimated_delivery_date
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Stores the estimated delivery date presented to the customer when the shipment method was selected.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_estimated_delivery_date'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_estimated_delivery_date';

        PRINT N'        [+] Column description added      : SHP_estimated_delivery_date';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_estimated_delivery_date';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_estimated_delivery_date';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_estimated_delivery_date';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_tracking_code
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Stores the tracking code assigned to the shipment when available.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_tracking_code'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_tracking_code';

        PRINT N'        [+] Column description added      : SHP_tracking_code';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_tracking_code';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_tracking_code';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_tracking_code';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_posted_at
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Records the date and time when the shipment was handed over to the delivery provider.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_posted_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_posted_at';

        PRINT N'        [+] Column description added      : SHP_posted_at';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_posted_at';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_posted_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_posted_at';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_delivered_at
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
        N'Records the date and time when the shipment was successfully delivered to the recipient.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_delivered_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_delivered_at';

        PRINT N'        [+] Column description added      : SHP_delivered_at';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_delivered_at';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_delivered_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_delivered_at';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_created_at
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
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
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_created_at';

        PRINT N'        [+] Column description added      : SHP_created_at';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_created_at';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_created_at';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHP_updated_at
    ----------------------------------------------------------------------*/

    SET @SHP_expected_description =
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
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'Shipment',
            @level2type = N'COLUMN',
            @level2name = N'SHP_updated_at';

        PRINT N'        [+] Column description added      : SHP_updated_at';

    END
    ELSE
    BEGIN

        SET @SHP_existing_description = NULL;


        SELECT
            @SHP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'shipping.Shipment')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'SHP_updated_at';


        IF @SHP_existing_description =
            @SHP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHP_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHP_updated_at';
            PRINT N'            Expected                     : '
                + @SHP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHP_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';