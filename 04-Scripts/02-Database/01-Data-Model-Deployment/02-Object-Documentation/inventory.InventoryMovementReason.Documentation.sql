    PRINT N'';
    PRINT N'    ● inventory.InventoryMovementReason';
    PRINT N'';

    DECLARE @INVMR_expected_description nvarchar(4000);
    DECLARE @INVMR_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @INVMR_expected_description =
        N'Maintains the controlled reasons used to classify inventory movements in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementReason';

        PRINT N'        [+] Table description added       : inventory.InventoryMovementReason';

    END
    ELSE
    BEGIN

        SET @INVMR_existing_description = NULL;


        SELECT
            @INVMR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @INVMR_existing_description =
            @INVMR_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : inventory.InventoryMovementReason';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : inventory.InventoryMovementReason';
            PRINT N'            Expected                     : '
                + @INVMR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMR_id
    ----------------------------------------------------------------------*/

    SET @INVMR_expected_description =
        N'Primary key of inventory.InventoryMovementReason.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMR_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementReason',
            @level2type = N'COLUMN',
            @level2name = N'INVMR_id';

        PRINT N'        [+] Column description added      : INVMR_id';

    END
    ELSE
    BEGIN

        SET @INVMR_existing_description = NULL;


        SELECT
            @INVMR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMR_id';


        IF @INVMR_existing_description =
            @INVMR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMR_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMR_id';
            PRINT N'            Expected                     : '
                + @INVMR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMR_name
    ----------------------------------------------------------------------*/

    SET @INVMR_expected_description =
        N'Stores the controlled business name of the inventory movement reason.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMR_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementReason',
            @level2type = N'COLUMN',
            @level2name = N'INVMR_name';

        PRINT N'        [+] Column description added      : INVMR_name';

    END
    ELSE
    BEGIN

        SET @INVMR_existing_description = NULL;


        SELECT
            @INVMR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMR_name';


        IF @INVMR_existing_description =
            @INVMR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMR_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMR_name';
            PRINT N'            Expected                     : '
                + @INVMR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMR_created_at
    ----------------------------------------------------------------------*/

    SET @INVMR_expected_description =
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
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMR_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementReason',
            @level2type = N'COLUMN',
            @level2name = N'INVMR_created_at';

        PRINT N'        [+] Column description added      : INVMR_created_at';

    END
    ELSE
    BEGIN

        SET @INVMR_existing_description = NULL;


        SELECT
            @INVMR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMR_created_at';


        IF @INVMR_existing_description =
            @INVMR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMR_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMR_created_at';
            PRINT N'            Expected                     : '
                + @INVMR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMR_updated_at
    ----------------------------------------------------------------------*/

    SET @INVMR_expected_description =
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
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMR_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementReason',
            @level2type = N'COLUMN',
            @level2name = N'INVMR_updated_at';

        PRINT N'        [+] Column description added      : INVMR_updated_at';

    END
    ELSE
    BEGIN

        SET @INVMR_existing_description = NULL;


        SELECT
            @INVMR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMR_updated_at';


        IF @INVMR_existing_description =
            @INVMR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMR_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMR_updated_at';
            PRINT N'            Expected                     : '
                + @INVMR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMR_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';