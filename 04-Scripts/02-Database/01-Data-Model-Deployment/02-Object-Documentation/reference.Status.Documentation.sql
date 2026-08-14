    PRINT N'    reference.Status';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @STS_expected_description nvarchar(4000);
    DECLARE @STS_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @STS_expected_description =
        N'Maintains reusable status values shared across Atlas Commerce domains where a simple active or inactive state is required.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @STS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Status';

        PRINT N'        [+] Table description added       : reference.Status';

    END
    ELSE
    BEGIN

        SET @STS_existing_description = NULL;

        SELECT
            @STS_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @STS_existing_description = @STS_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : reference.Status';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : reference.Status';
            PRINT N'            Expected                     : '
                + @STS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @STS_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@STS_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @STS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: STS_id
    ----------------------------------------------------------------------*/

    SET @STS_expected_description =
        N'Primary key of reference.Status.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @STS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Status',
            @level2type = N'COLUMN',
            @level2name = N'STS_id';

        PRINT N'        [+] Column description added      : STS_id';

    END
    ELSE
    BEGIN

        SET @STS_existing_description = NULL;

        SELECT
            @STS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_id';

        IF @STS_existing_description = @STS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : STS_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : STS_id';
            PRINT N'            Expected                     : '
                + @STS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @STS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@STS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @STS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: STS_code
    ----------------------------------------------------------------------*/

    SET @STS_expected_description =
        N'Stores the unique stable code used to identify the status programmatically.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_code'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @STS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Status',
            @level2type = N'COLUMN',
            @level2name = N'STS_code';

        PRINT N'        [+] Column description added      : STS_code';

    END
    ELSE
    BEGIN

        SET @STS_existing_description = NULL;

        SELECT
            @STS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_code';

        IF @STS_existing_description = @STS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : STS_code';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : STS_code';
            PRINT N'            Expected                     : '
                + @STS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @STS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@STS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @STS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: STS_name
    ----------------------------------------------------------------------*/

    SET @STS_expected_description =
        N'Stores the descriptive name of the status for human-readable use.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @STS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Status',
            @level2type = N'COLUMN',
            @level2name = N'STS_name';

        PRINT N'        [+] Column description added      : STS_name';

    END
    ELSE
    BEGIN

        SET @STS_existing_description = NULL;

        SELECT
            @STS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_name';

        IF @STS_existing_description = @STS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : STS_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : STS_name';
            PRINT N'            Expected                     : '
                + @STS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @STS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@STS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @STS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: STS_created_at
    ----------------------------------------------------------------------*/

    SET @STS_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @STS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Status',
            @level2type = N'COLUMN',
            @level2name = N'STS_created_at';

        PRINT N'        [+] Column description added      : STS_created_at';

    END
    ELSE
    BEGIN

        SET @STS_existing_description = NULL;

        SELECT
            @STS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_created_at';

        IF @STS_existing_description = @STS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : STS_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : STS_created_at';
            PRINT N'            Expected                     : '
                + @STS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @STS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@STS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @STS_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: STS_updated_at
    ----------------------------------------------------------------------*/

    SET @STS_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @STS_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Status',
            @level2type = N'COLUMN',
            @level2name = N'STS_updated_at';

        PRINT N'        [+] Column description added      : STS_updated_at';

    END
    ELSE
    BEGIN

        SET @STS_existing_description = NULL;

        SELECT
            @STS_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.Status')
        AND ep.name = N'MS_Description'
        AND c.name = N'STS_updated_at';

        IF @STS_existing_description = @STS_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : STS_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : STS_updated_at';
            PRINT N'            Expected                     : '
                + @STS_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @STS_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@STS_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @STS_existing_description
                END;

        END;

    END;


    PRINT N'';