    PRINT N'';
    PRINT N'    ● reference.City';
    PRINT N'';

    DECLARE @CTY_expected_description nvarchar(4000);
    DECLARE @CTY_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CTY_expected_description =
        N'Maintains controlled Brazilian cities associated with administrative divisions in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'City';

        PRINT N'        [+] Table description added       : reference.City';

    END
    ELSE
    BEGIN

        SET @CTY_existing_description = NULL;


        SELECT
            @CTY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @CTY_existing_description =
            @CTY_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : reference.City';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : reference.City';
            PRINT N'            Expected                     : '
                + @CTY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTY_id
    ----------------------------------------------------------------------*/

    SET @CTY_expected_description =
        N'Primary key of reference.City.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'City',
            @level2type = N'COLUMN',
            @level2name = N'CTY_id';

        PRINT N'        [+] Column description added      : CTY_id';

    END
    ELSE
    BEGIN

        SET @CTY_existing_description = NULL;


        SELECT
            @CTY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_id';


        IF @CTY_existing_description =
            @CTY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTY_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTY_id';
            PRINT N'            Expected                     : '
                + @CTY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTY_ADV_id
    ----------------------------------------------------------------------*/

    SET @CTY_expected_description =
        N'Foreign key referencing reference.AdministrativeDivision.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_ADV_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'City',
            @level2type = N'COLUMN',
            @level2name = N'CTY_ADV_id';

        PRINT N'        [+] Column description added      : CTY_ADV_id';

    END
    ELSE
    BEGIN

        SET @CTY_existing_description = NULL;


        SELECT
            @CTY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_ADV_id';


        IF @CTY_existing_description =
            @CTY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTY_ADV_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTY_ADV_id';
            PRINT N'            Expected                     : '
                + @CTY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTY_name
    ----------------------------------------------------------------------*/

    SET @CTY_expected_description =
        N'Stores the official name used to identify the city.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'City',
            @level2type = N'COLUMN',
            @level2name = N'CTY_name';

        PRINT N'        [+] Column description added      : CTY_name';

    END
    ELSE
    BEGIN

        SET @CTY_existing_description = NULL;


        SELECT
            @CTY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_name';


        IF @CTY_existing_description =
            @CTY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTY_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTY_name';
            PRINT N'            Expected                     : '
                + @CTY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTY_created_at
    ----------------------------------------------------------------------*/

    SET @CTY_expected_description =
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
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'City',
            @level2type = N'COLUMN',
            @level2name = N'CTY_created_at';

        PRINT N'        [+] Column description added      : CTY_created_at';

    END
    ELSE
    BEGIN

        SET @CTY_existing_description = NULL;


        SELECT
            @CTY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_created_at';


        IF @CTY_existing_description =
            @CTY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTY_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTY_created_at';
            PRINT N'            Expected                     : '
                + @CTY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTY_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTY_updated_at
    ----------------------------------------------------------------------*/

    SET @CTY_expected_description =
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
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTY_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'City',
            @level2type = N'COLUMN',
            @level2name = N'CTY_updated_at';

        PRINT N'        [+] Column description added      : CTY_updated_at';

    END
    ELSE
    BEGIN

        SET @CTY_existing_description = NULL;


        SELECT
            @CTY_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.City')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CTY_updated_at';


        IF @CTY_existing_description =
            @CTY_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTY_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTY_updated_at';
            PRINT N'            Expected                     : '
                + @CTY_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTY_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTY_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTY_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';