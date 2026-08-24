    PRINT N'';
    PRINT N'    ● reference.AdministrativeDivision';
    PRINT N'';

    DECLARE @ADV_expected_description nvarchar(4000);
    DECLARE @ADV_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @ADV_expected_description =
        N'Maintains controlled Brazilian administrative divisions associated with countries in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'AdministrativeDivision';

        PRINT N'        [+] Table description added       : reference.AdministrativeDivision';

    END
    ELSE
    BEGIN

        SET @ADV_existing_description = NULL;


        SELECT
            @ADV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @ADV_existing_description =
            @ADV_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : reference.AdministrativeDivision';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : reference.AdministrativeDivision';
            PRINT N'            Expected                     : '
                + @ADV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADV_id
    ----------------------------------------------------------------------*/

    SET @ADV_expected_description =
        N'Primary key of reference.AdministrativeDivision.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'AdministrativeDivision',
            @level2type = N'COLUMN',
            @level2name = N'ADV_id';

        PRINT N'        [+] Column description added      : ADV_id';

    END
    ELSE
    BEGIN

        SET @ADV_existing_description = NULL;


        SELECT
            @ADV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_id';


        IF @ADV_existing_description =
            @ADV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADV_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADV_id';
            PRINT N'            Expected                     : '
                + @ADV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADV_CTR_id
    ----------------------------------------------------------------------*/

    SET @ADV_expected_description =
        N'Foreign key referencing reference.Country.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_CTR_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'AdministrativeDivision',
            @level2type = N'COLUMN',
            @level2name = N'ADV_CTR_id';

        PRINT N'        [+] Column description added      : ADV_CTR_id';

    END
    ELSE
    BEGIN

        SET @ADV_existing_description = NULL;


        SELECT
            @ADV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_CTR_id';


        IF @ADV_existing_description =
            @ADV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADV_CTR_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADV_CTR_id';
            PRINT N'            Expected                     : '
                + @ADV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADV_code
    ----------------------------------------------------------------------*/

    SET @ADV_expected_description =
        N'Stores the official two-character abbreviation of the administrative division.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_code'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'AdministrativeDivision',
            @level2type = N'COLUMN',
            @level2name = N'ADV_code';

        PRINT N'        [+] Column description added      : ADV_code';

    END
    ELSE
    BEGIN

        SET @ADV_existing_description = NULL;


        SELECT
            @ADV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_code';


        IF @ADV_existing_description =
            @ADV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADV_code';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADV_code';
            PRINT N'            Expected                     : '
                + @ADV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADV_name
    ----------------------------------------------------------------------*/

    SET @ADV_expected_description =
        N'Stores the official name used to identify the administrative division.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'AdministrativeDivision',
            @level2type = N'COLUMN',
            @level2name = N'ADV_name';

        PRINT N'        [+] Column description added      : ADV_name';

    END
    ELSE
    BEGIN

        SET @ADV_existing_description = NULL;


        SELECT
            @ADV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_name';


        IF @ADV_existing_description =
            @ADV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADV_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADV_name';
            PRINT N'            Expected                     : '
                + @ADV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADV_created_at
    ----------------------------------------------------------------------*/

    SET @ADV_expected_description =
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'AdministrativeDivision',
            @level2type = N'COLUMN',
            @level2name = N'ADV_created_at';

        PRINT N'        [+] Column description added      : ADV_created_at';

    END
    ELSE
    BEGIN

        SET @ADV_existing_description = NULL;


        SELECT
            @ADV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_created_at';


        IF @ADV_existing_description =
            @ADV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADV_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADV_created_at';
            PRINT N'            Expected                     : '
                + @ADV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADV_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADV_updated_at
    ----------------------------------------------------------------------*/

    SET @ADV_expected_description =
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADV_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'AdministrativeDivision',
            @level2type = N'COLUMN',
            @level2name = N'ADV_updated_at';

        PRINT N'        [+] Column description added      : ADV_updated_at';

    END
    ELSE
    BEGIN

        SET @ADV_existing_description = NULL;


        SELECT
            @ADV_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADV_updated_at';


        IF @ADV_existing_description =
            @ADV_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADV_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADV_updated_at';
            PRINT N'            Expected                     : '
                + @ADV_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADV_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADV_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADV_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';