    PRINT N'    inventory.InventoryMovement';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @INVMV_expected_description nvarchar(4000);
    DECLARE @INVMV_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Maintains the historical inventory movements for each product variant in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement';

        PRINT N'        [+] Table description added       : inventory.InventoryMovement';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Table description validated   : inventory.InventoryMovement';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Table description mismatch    : inventory.InventoryMovement';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_id
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Primary key of inventory.InventoryMovement.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_id';

        PRINT N'        [+] Column description added      : INVMV_id';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_id';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Column description validated  : INVMV_id';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_id';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_PRDVA_id
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Foreign key of catalog.ProductVariant.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_PRDVA_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_PRDVA_id';

        PRINT N'        [+] Column description added      : INVMV_PRDVA_id';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_PRDVA_id';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Column description validated  : INVMV_PRDVA_id';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_PRDVA_id';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_INVMR_id
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Foreign key of inventory.InventoryMovementReason.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_INVMR_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_INVMR_id';

        PRINT N'        [+] Column description added      : INVMV_INVMR_id';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_INVMR_id';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Column description validated  : INVMV_INVMR_id';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_INVMR_id';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_TRNIT_id
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Optional identifier component of the composite foreign key to sales.TransactionItem when the movement originates from a sales transaction item.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_TRNIT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_TRNIT_id';

        PRINT N'        [+] Column description added      : INVMV_TRNIT_id';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_TRNIT_id';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Column description validated  : INVMV_TRNIT_id';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_TRNIT_id';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_TRNIT_transaction_at
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Optional transaction date component of the composite foreign key to sales.TransactionItem.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_TRNIT_transaction_at'
    )
    BEGIN
        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_TRNIT_transaction_at';

        PRINT N'        [+] Column description added      : INVMV_TRNIT_transaction_at';
    END
    ELSE
    BEGIN
        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description = CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_TRNIT_transaction_at';

        IF @INVMV_existing_description = @INVMV_expected_description
            PRINT N'        [•] Column description validated  : INVMV_TRNIT_transaction_at';
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_TRNIT_transaction_at';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;
    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_quantity
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Stores the signed inventory quantity moved. Positive values represent entries and negative values represent exits.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_quantity'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_quantity';

        PRINT N'        [+] Column description added      : INVMV_quantity';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_quantity';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Column description validated  : INVMV_quantity';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_quantity';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_movement_at
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Records the date and time when the inventory movement actually occurred.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_movement_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_movement_at';

        PRINT N'        [+] Column description added      : INVMV_movement_at';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_movement_at';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Column description validated  : INVMV_movement_at';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_movement_at';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_created_at
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_created_at';

        PRINT N'        [+] Column description added      : INVMV_created_at';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_created_at';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Column description validated  : INVMV_created_at';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_created_at';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMV_updated_at
    ----------------------------------------------------------------------*/

    SET @INVMV_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovement',
            @level2type = N'COLUMN',
            @level2name = N'INVMV_updated_at';

        PRINT N'        [+] Column description added      : INVMV_updated_at';

    END
    ELSE
    BEGIN

        SET @INVMV_existing_description = NULL;

        SELECT
            @INVMV_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryMovement')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVMV_updated_at';

        IF @INVMV_existing_description = @INVMV_expected_description
        BEGIN
            PRINT N'        [•] Column description validated  : INVMV_updated_at';
        END
        ELSE
        BEGIN
            PRINT N'        [!] Column description mismatch   : INVMV_updated_at';
            PRINT N'            Expected                     : ' + @INVMV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMV_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVMV_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVMV_existing_description
                  END;
        END;

    END;

    PRINT N'';