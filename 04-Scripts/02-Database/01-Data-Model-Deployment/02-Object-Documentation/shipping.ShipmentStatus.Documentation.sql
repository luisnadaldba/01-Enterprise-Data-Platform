    PRINT N'    shipping.ShipmentStatus';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @SHPST_expected_description nvarchar(4000);
    DECLARE @SHPST_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @SHPST_expected_description =
        N'Defines the controlled statuses used to represent the operational lifecycle of Atlas Commerce shipments.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentStatus';

        PRINT N'        [+] Table description added       : shipping.ShipmentStatus';

    END
    ELSE
    BEGIN

        SET @SHPST_existing_description = NULL;

        SELECT
            @SHPST_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @SHPST_existing_description = @SHPST_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : shipping.ShipmentStatus';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : shipping.ShipmentStatus';
            PRINT N'            Expected                     : '
                + @SHPST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@SHPST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @SHPST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHPST_id
    ----------------------------------------------------------------------*/

    SET @SHPST_expected_description =
        N'Primary key of shipping.ShipmentStatus.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentStatus',
            @level2type = N'COLUMN',
            @level2name = N'SHPST_id';

        PRINT N'        [+] Column description added      : SHPST_id';

    END
    ELSE
    BEGIN

        SET @SHPST_existing_description = NULL;

        SELECT
            @SHPST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPST_id';

        IF @SHPST_existing_description = @SHPST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHPST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHPST_id';
            PRINT N'            Expected                     : '
                + @SHPST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@SHPST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @SHPST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHPST_name
    ----------------------------------------------------------------------*/

    SET @SHPST_expected_description =
        N'Stores the controlled shipment status representing the current operational state of a shipment.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPST_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentStatus',
            @level2type = N'COLUMN',
            @level2name = N'SHPST_name';

        PRINT N'        [+] Column description added      : SHPST_name';

    END
    ELSE
    BEGIN

        SET @SHPST_existing_description = NULL;

        SELECT
            @SHPST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPST_name';

        IF @SHPST_existing_description = @SHPST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHPST_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHPST_name';
            PRINT N'            Expected                     : '
                + @SHPST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@SHPST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @SHPST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHPST_created_at
    ----------------------------------------------------------------------*/

    SET @SHPST_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPST_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentStatus',
            @level2type = N'COLUMN',
            @level2name = N'SHPST_created_at';

        PRINT N'        [+] Column description added      : SHPST_created_at';

    END
    ELSE
    BEGIN

        SET @SHPST_existing_description = NULL;

        SELECT
            @SHPST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPST_created_at';

        IF @SHPST_existing_description = @SHPST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHPST_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHPST_created_at';
            PRINT N'            Expected                     : '
                + @SHPST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@SHPST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @SHPST_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: SHPST_updated_at
    ----------------------------------------------------------------------*/

    SET @SHPST_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPST_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @SHPST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'shipping',
            @level1type = N'TABLE',
            @level1name = N'ShipmentStatus',
            @level2type = N'COLUMN',
            @level2name = N'SHPST_updated_at';

        PRINT N'        [+] Column description added      : SHPST_updated_at';

    END
    ELSE
    BEGIN

        SET @SHPST_existing_description = NULL;

        SELECT
            @SHPST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'shipping.ShipmentStatus')
        AND ep.name = N'MS_Description'
        AND c.name = N'SHPST_updated_at';

        IF @SHPST_existing_description = @SHPST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : SHPST_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : SHPST_updated_at';
            PRINT N'            Expected                     : '
                + @SHPST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @SHPST_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@SHPST_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @SHPST_existing_description
                END;

        END;

    END;


    PRINT N'';