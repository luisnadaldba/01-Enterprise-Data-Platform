    PRINT N'    catalog.Brand';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @BRD_expected_description nvarchar(4000);
    DECLARE @BRD_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @BRD_expected_description =
        N'Maintains the controlled set of commercial brands used to consistently classify products in the Atlas Commerce catalog.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @BRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Brand';

        PRINT N'        [+] Table description added       : catalog.Brand';

    END
    ELSE
    BEGIN

        SET @BRD_existing_description = NULL;

        SELECT
            @BRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @BRD_existing_description = @BRD_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : catalog.Brand';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : catalog.Brand';
            PRINT N'            Expected                     : '
                + @BRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @BRD_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@BRD_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @BRD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: BRD_id
    ----------------------------------------------------------------------*/

    SET @BRD_expected_description =
        N'Primary key of catalog.Brand.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @BRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Brand',
            @level2type = N'COLUMN',
            @level2name = N'BRD_id';

        PRINT N'        [+] Column description added      : BRD_id';

    END
    ELSE
    BEGIN

        SET @BRD_existing_description = NULL;

        SELECT
            @BRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_id';

        IF @BRD_existing_description = @BRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : BRD_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : BRD_id';
            PRINT N'            Expected                     : '
                + @BRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @BRD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@BRD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @BRD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: BRD_name
    ----------------------------------------------------------------------*/

    SET @BRD_expected_description =
        N'Stores the commercial name used to identify the brand associated with catalog products.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @BRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Brand',
            @level2type = N'COLUMN',
            @level2name = N'BRD_name';

        PRINT N'        [+] Column description added      : BRD_name';

    END
    ELSE
    BEGIN

        SET @BRD_existing_description = NULL;

        SELECT
            @BRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_name';

        IF @BRD_existing_description = @BRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : BRD_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : BRD_name';
            PRINT N'            Expected                     : '
                + @BRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @BRD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@BRD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @BRD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: BRD_is_active
    ----------------------------------------------------------------------*/

    SET @BRD_expected_description =
        N'Indicates whether the brand is currently available for use in catalog operations while preserving inactive brands for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @BRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Brand',
            @level2type = N'COLUMN',
            @level2name = N'BRD_is_active';

        PRINT N'        [+] Column description added      : BRD_is_active';

    END
    ELSE
    BEGIN

        SET @BRD_existing_description = NULL;

        SELECT
            @BRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_is_active';

        IF @BRD_existing_description = @BRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : BRD_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : BRD_is_active';
            PRINT N'            Expected                     : '
                + @BRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @BRD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@BRD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @BRD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: BRD_created_at
    ----------------------------------------------------------------------*/

    SET @BRD_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @BRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Brand',
            @level2type = N'COLUMN',
            @level2name = N'BRD_created_at';

        PRINT N'        [+] Column description added      : BRD_created_at';

    END
    ELSE
    BEGIN

        SET @BRD_existing_description = NULL;

        SELECT
            @BRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_created_at';

        IF @BRD_existing_description = @BRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : BRD_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : BRD_created_at';
            PRINT N'            Expected                     : '
                + @BRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @BRD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@BRD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @BRD_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: BRD_updated_at
    ----------------------------------------------------------------------*/

    SET @BRD_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @BRD_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'catalog',
            @level1type = N'TABLE',
            @level1name = N'Brand',
            @level2type = N'COLUMN',
            @level2name = N'BRD_updated_at';

        PRINT N'        [+] Column description added      : BRD_updated_at';

    END
    ELSE
    BEGIN

        SET @BRD_existing_description = NULL;

        SELECT
            @BRD_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'catalog.Brand')
        AND ep.name = N'MS_Description'
        AND c.name = N'BRD_updated_at';

        IF @BRD_existing_description = @BRD_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : BRD_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : BRD_updated_at';
            PRINT N'            Expected                     : '
                + @BRD_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @BRD_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@BRD_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @BRD_existing_description
                END;

        END;

    END;


    PRINT N'';