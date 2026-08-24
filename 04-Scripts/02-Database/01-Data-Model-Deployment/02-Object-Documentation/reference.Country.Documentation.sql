    PRINT N'';
    PRINT N'    ● reference.Country';
    PRINT N'';

    DECLARE @CTR_expected_description nvarchar(4000);
    DECLARE @CTR_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CTR_expected_description =
        N'Maintains controlled countries used by Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Country')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Country';

        PRINT N'        [+] Table description added       : reference.Country';

    END
    ELSE
    BEGIN

        SET @CTR_existing_description = NULL;


        SELECT
            @CTR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Country')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @CTR_existing_description =
            @CTR_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : reference.Country';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : reference.Country';
            PRINT N'            Expected                     : '
                + @CTR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTR_id
    ----------------------------------------------------------------------*/

    SET @CTR_expected_description =
        N'Primary key of reference.Country.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Country')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTR_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Country',
            @level2type = N'COLUMN',
            @level2name = N'CTR_id';

        PRINT N'        [+] Column description added      : CTR_id';

    END
    ELSE
    BEGIN

        SET @CTR_existing_description = NULL;


        SELECT
            @CTR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Country')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTR_id';


        IF @CTR_existing_description =
            @CTR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTR_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTR_id';
            PRINT N'            Expected                     : '
                + @CTR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTR_name
    ----------------------------------------------------------------------*/

    SET @CTR_expected_description =
        N'Stores the official name used to identify the country.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Country')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTR_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Country',
            @level2type = N'COLUMN',
            @level2name = N'CTR_name';

        PRINT N'        [+] Column description added      : CTR_name';

    END
    ELSE
    BEGIN

        SET @CTR_existing_description = NULL;


        SELECT
            @CTR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Country')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTR_name';


        IF @CTR_existing_description =
            @CTR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTR_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTR_name';
            PRINT N'            Expected                     : '
                + @CTR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTR_created_at
    ----------------------------------------------------------------------*/

    SET @CTR_expected_description =
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
                OBJECT_ID(N'reference.Country')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTR_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Country',
            @level2type = N'COLUMN',
            @level2name = N'CTR_created_at';

        PRINT N'        [+] Column description added      : CTR_created_at';

    END
    ELSE
    BEGIN

        SET @CTR_existing_description = NULL;


        SELECT
            @CTR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Country')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTR_created_at';


        IF @CTR_existing_description =
            @CTR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTR_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTR_created_at';
            PRINT N'            Expected                     : '
                + @CTR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTR_updated_at
    ----------------------------------------------------------------------*/

    SET @CTR_expected_description =
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
                OBJECT_ID(N'reference.Country')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTR_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Country',
            @level2type = N'COLUMN',
            @level2name = N'CTR_updated_at';

        PRINT N'        [+] Column description added      : CTR_updated_at';

    END
    ELSE
    BEGIN

        SET @CTR_existing_description = NULL;


        SELECT
            @CTR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Country')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTR_updated_at';


        IF @CTR_existing_description =
            @CTR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTR_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTR_updated_at';
            PRINT N'            Expected                     : '
                + @CTR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTR_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';