    PRINT N'    inventory.InventoryReservation';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @INVRE_expected_description nvarchar(4000);
    DECLARE @INVRE_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Maintains the current inventory reservation associated with each sales transaction item and its lifecycle in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation';

        PRINT N'        [+] Table description added       : inventory.InventoryReservation';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @INVRE_existing_description = @INVRE_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : inventory.InventoryReservation';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : inventory.InventoryReservation';
            PRINT N'            Expected                     : '
                + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVRE_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVRE_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVRE_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_id
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Primary key of inventory.InventoryReservation.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_id';

        PRINT N'        [+] Column description added      : INVRE_id';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_id';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_id';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_id';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_TRNIT_id
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Identifier component of the composite foreign key to sales.TransactionItem that owns the reservation.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_TRNIT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_TRNIT_id';

        PRINT N'        [+] Column description added      : INVRE_TRNIT_id';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_TRNIT_id';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_TRNIT_id';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_TRNIT_id';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_TRNIT_transaction_at
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Transaction date component of the composite foreign key to sales.TransactionItem.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_TRNIT_transaction_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_TRNIT_transaction_at';

        PRINT N'        [+] Column description added      : INVRE_TRNIT_transaction_at';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_TRNIT_transaction_at';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_TRNIT_transaction_at';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_TRNIT_transaction_at';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_PRDVA_id
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Foreign key of catalog.ProductVariant identifying the product variant reserved.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_PRDVA_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_PRDVA_id';

        PRINT N'        [+] Column description added      : INVRE_PRDVA_id';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_PRDVA_id';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_PRDVA_id';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_PRDVA_id';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_INVRS_id
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Foreign key of inventory.InventoryReservationStatus identifying the current reservation status.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_INVRS_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_INVRS_id';

        PRINT N'        [+] Column description added      : INVRE_INVRS_id';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_INVRS_id';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_INVRS_id';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_INVRS_id';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_quantity
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Stores the quantity of usable inventory units committed to the reservation.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_quantity'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_quantity';

        PRINT N'        [+] Column description added      : INVRE_quantity';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_quantity';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_quantity';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_quantity';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_reserved_at
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Records the date and time when the inventory reservation became effective.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_reserved_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_reserved_at';

        PRINT N'        [+] Column description added      : INVRE_reserved_at';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_reserved_at';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_reserved_at';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_reserved_at';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_expires_at
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Records the date and time when the reservation is expected to expire if it is not consumed or released earlier.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_expires_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_expires_at';

        PRINT N'        [+] Column description added      : INVRE_expires_at';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_expires_at';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_expires_at';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_expires_at';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_closed_at
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Records the date and time when the reservation was consumed, released, or expired; NULL while the reservation remains active.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_closed_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_closed_at';

        PRINT N'        [+] Column description added      : INVRE_closed_at';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_closed_at';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_closed_at';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_closed_at';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_created_at
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_created_at';

        PRINT N'        [+] Column description added      : INVRE_created_at';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_created_at';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_created_at';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_created_at';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRE_updated_at
    ----------------------------------------------------------------------*/

    SET @INVRE_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRE_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservation',
            @level2type = N'COLUMN',
            @level2name = N'INVRE_updated_at';

        PRINT N'        [+] Column description added      : INVRE_updated_at';

    END
    ELSE
    BEGIN

        SET @INVRE_existing_description = NULL;

        SELECT
            @INVRE_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON c.object_id = ep.major_id
        AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservation')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRE_updated_at';

        IF @INVRE_existing_description = @INVRE_expected_description
            PRINT N'        [•] Column description validated  : INVRE_updated_at';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVRE_updated_at';
            PRINT N'            Expected                     : ' + @INVRE_expected_description;
            PRINT N'            Actual                       : '
                + COALESCE(NULLIF(@INVRE_existing_description, N''), N'<NULL>');
        END;

    END;


    PRINT N'';