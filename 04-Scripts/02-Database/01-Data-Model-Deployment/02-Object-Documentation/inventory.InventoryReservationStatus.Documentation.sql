    PRINT N'    inventory.InventoryReservationStatus';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @INVRS_expected_description nvarchar(4000);
    DECLARE @INVRS_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @INVRS_expected_description =
        N'Defines the controlled statuses used to represent the lifecycle of inventory reservations in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservationStatus';

        PRINT N'        [+] Table description added       : inventory.InventoryReservationStatus';

    END
    ELSE
    BEGIN

        SET @INVRS_existing_description = NULL;

        SELECT
            @INVRS_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @INVRS_existing_description = @INVRS_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : inventory.InventoryReservationStatus';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : inventory.InventoryReservationStatus';
            PRINT N'            Expected                     : '
                + @INVRS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVRS_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVRS_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVRS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRS_id
    ----------------------------------------------------------------------*/

    SET @INVRS_expected_description =
        N'Primary key of inventory.InventoryReservationStatus.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRS_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservationStatus',
            @level2type = N'COLUMN',
            @level2name = N'INVRS_id';

        PRINT N'        [+] Column description added      : INVRS_id';

    END
    ELSE
    BEGIN

        SET @INVRS_existing_description = NULL;

        SELECT
            @INVRS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRS_id';

        IF @INVRS_existing_description = @INVRS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVRS_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVRS_id';
            PRINT N'            Expected                     : '
                + @INVRS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVRS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVRS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVRS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRS_name
    ----------------------------------------------------------------------*/

    SET @INVRS_expected_description =
        N'Stores the controlled name of the inventory reservation status used by Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRS_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservationStatus',
            @level2type = N'COLUMN',
            @level2name = N'INVRS_name';

        PRINT N'        [+] Column description added      : INVRS_name';

    END
    ELSE
    BEGIN

        SET @INVRS_existing_description = NULL;

        SELECT
            @INVRS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRS_name';

        IF @INVRS_existing_description = @INVRS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVRS_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVRS_name';
            PRINT N'            Expected                     : '
                + @INVRS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVRS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVRS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVRS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRS_created_at
    ----------------------------------------------------------------------*/

    SET @INVRS_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRS_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservationStatus',
            @level2type = N'COLUMN',
            @level2name = N'INVRS_created_at';

        PRINT N'        [+] Column description added      : INVRS_created_at';

    END
    ELSE
    BEGIN

        SET @INVRS_existing_description = NULL;

        SELECT
            @INVRS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRS_created_at';

        IF @INVRS_existing_description = @INVRS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVRS_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVRS_created_at';
            PRINT N'            Expected                     : '
                + @INVRS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVRS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVRS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVRS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVRS_updated_at
    ----------------------------------------------------------------------*/

    SET @INVRS_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRS_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVRS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryReservationStatus',
            @level2type = N'COLUMN',
            @level2name = N'INVRS_updated_at';

        PRINT N'        [+] Column description added      : INVRS_updated_at';

    END
    ELSE
    BEGIN

        SET @INVRS_existing_description = NULL;

        SELECT
            @INVRS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'inventory.InventoryReservationStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'INVRS_updated_at';

        IF @INVRS_existing_description = @INVRS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVRS_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVRS_updated_at';
            PRINT N'            Expected                     : '
                + @INVRS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVRS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@INVRS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @INVRS_existing_description
                END;

        END;

    END;


    PRINT N'';