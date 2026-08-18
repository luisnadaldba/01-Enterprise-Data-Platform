    PRINT N'    shipping.ShipmentMethod';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @SHPMT_expected_description nvarchar(4000);
    DECLARE @SHPMT_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @SHPMT_expected_description =
        N'Defines the controlled shipment methods available for Atlas Commerce deliveries.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPMT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentMethod';

        PRINT N'        [+] Table description added       : shipping.ShipmentMethod';

    END
    ELSE
    BEGIN

        SET @SHPMT_existing_description = NULL;

        SELECT
            @SHPMT_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @SHPMT_existing_description = @SHPMT_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : shipping.ShipmentMethod';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : shipping.ShipmentMethod';
            PRINT N'            Expected                     : '
                + @SHPMT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPMT_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHPMT_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHPMT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHPMT_id
    ----------------------------------------------------------------------*/

    SET @SHPMT_expected_description =
        N'Primary key of shipping.ShipmentMethod.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPMT_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPMT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentMethod',
            @level2type = N'COLUMN',
            @level2name = N'SHPMT_id';

        PRINT N'        [+] Column description added      : SHPMT_id';

    END
    ELSE
    BEGIN

        SET @SHPMT_existing_description = NULL;

        SELECT
            @SHPMT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPMT_id';

        IF @SHPMT_existing_description = @SHPMT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHPMT_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHPMT_id';
            PRINT N'            Expected                     : '
                + @SHPMT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPMT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@SHPMT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @SHPMT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHPMT_name
    ----------------------------------------------------------------------*/

    SET @SHPMT_expected_description =
        N'Stores the controlled shipment method selected for Atlas Commerce deliveries.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPMT_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPMT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentMethod',
            @level2type = N'COLUMN',
            @level2name = N'SHPMT_name';

        PRINT N'        [+] Column description added      : SHPMT_name';

    END
    ELSE
    BEGIN

        SET @SHPMT_existing_description = NULL;

        SELECT
            @SHPMT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPMT_name';

        IF @SHPMT_existing_description = @SHPMT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHPMT_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHPMT_name';
            PRINT N'            Expected                     : '
                + @SHPMT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPMT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@SHPMT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @SHPMT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHPMT_created_at
    ----------------------------------------------------------------------*/

    SET @SHPMT_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPMT_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPMT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentMethod',
            @level2type = N'COLUMN',
            @level2name = N'SHPMT_created_at';

        PRINT N'        [+] Column description added      : SHPMT_created_at';

    END
    ELSE
    BEGIN

        SET @SHPMT_existing_description = NULL;

        SELECT
            @SHPMT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPMT_created_at';

        IF @SHPMT_existing_description = @SHPMT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHPMT_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHPMT_created_at';
            PRINT N'            Expected                     : '
                + @SHPMT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPMT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@SHPMT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @SHPMT_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHPMT_updated_at
    ----------------------------------------------------------------------*/

    SET @SHPMT_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPMT_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPMT_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentMethod',
            @level2type = N'COLUMN',
            @level2name = N'SHPMT_updated_at';

        PRINT N'        [+] Column description added      : SHPMT_updated_at';

    END
    ELSE
    BEGIN

        SET @SHPMT_existing_description = NULL;

        SELECT
            @SHPMT_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentMethod')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPMT_updated_at';

        IF @SHPMT_existing_description = @SHPMT_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHPMT_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHPMT_updated_at';
            PRINT N'            Expected                     : '
                + @SHPMT_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPMT_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@SHPMT_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @SHPMT_existing_description
                END;

        END;

    END;


    PRINT N'';