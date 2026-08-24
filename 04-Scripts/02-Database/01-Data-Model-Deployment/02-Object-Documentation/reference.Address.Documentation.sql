    PRINT N'';
    PRINT N'    ● reference.Address';
    PRINT N'';

    DECLARE @ADR_expected_description nvarchar(4000);
    DECLARE @ADR_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @ADR_expected_description =
        N'Maintains reusable physical street address references associated with controlled cities in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Address';

        PRINT N'        [+] Table description added       : reference.Address';

    END
    ELSE
    BEGIN

        SET @ADR_existing_description = NULL;


        SELECT
            @ADR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @ADR_existing_description =
            @ADR_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : reference.Address';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : reference.Address';
            PRINT N'            Expected                     : '
                + @ADR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADR_id
    ----------------------------------------------------------------------*/

    SET @ADR_expected_description =
        N'Primary key of reference.Address.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Address',
            @level2type = N'COLUMN',
            @level2name = N'ADR_id';

        PRINT N'        [+] Column description added      : ADR_id';

    END
    ELSE
    BEGIN

        SET @ADR_existing_description = NULL;


        SELECT
            @ADR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_id';


        IF @ADR_existing_description =
            @ADR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADR_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADR_id';
            PRINT N'            Expected                     : '
                + @ADR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADR_CTY_id
    ----------------------------------------------------------------------*/

    SET @ADR_expected_description =
        N'Foreign key referencing reference.City.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_CTY_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Address',
            @level2type = N'COLUMN',
            @level2name = N'ADR_CTY_id';

        PRINT N'        [+] Column description added      : ADR_CTY_id';

    END
    ELSE
    BEGIN

        SET @ADR_existing_description = NULL;


        SELECT
            @ADR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_CTY_id';


        IF @ADR_existing_description =
            @ADR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADR_CTY_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADR_CTY_id';
            PRINT N'            Expected                     : '
                + @ADR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADR_postal_code
    ----------------------------------------------------------------------*/

    SET @ADR_expected_description =
        N'Stores the eight-digit Brazilian postal code without presentation formatting.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_postal_code'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Address',
            @level2type = N'COLUMN',
            @level2name = N'ADR_postal_code';

        PRINT N'        [+] Column description added      : ADR_postal_code';

    END
    ELSE
    BEGIN

        SET @ADR_existing_description = NULL;


        SELECT
            @ADR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_postal_code';


        IF @ADR_existing_description =
            @ADR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADR_postal_code';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADR_postal_code';
            PRINT N'            Expected                     : '
                + @ADR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADR_street
    ----------------------------------------------------------------------*/

    SET @ADR_expected_description =
        N'Stores the street or public-place name associated with the address reference.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_street'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Address',
            @level2type = N'COLUMN',
            @level2name = N'ADR_street';

        PRINT N'        [+] Column description added      : ADR_street';

    END
    ELSE
    BEGIN

        SET @ADR_existing_description = NULL;


        SELECT
            @ADR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_street';


        IF @ADR_existing_description =
            @ADR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADR_street';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADR_street';
            PRINT N'            Expected                     : '
                + @ADR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADR_created_at
    ----------------------------------------------------------------------*/

    SET @ADR_expected_description =
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
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Address',
            @level2type = N'COLUMN',
            @level2name = N'ADR_created_at';

        PRINT N'        [+] Column description added      : ADR_created_at';

    END
    ELSE
    BEGIN

        SET @ADR_existing_description = NULL;


        SELECT
            @ADR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_created_at';


        IF @ADR_existing_description =
            @ADR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADR_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADR_created_at';
            PRINT N'            Expected                     : '
                + @ADR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADR_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: ADR_updated_at
    ----------------------------------------------------------------------*/

    SET @ADR_expected_description =
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
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @ADR_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'Address',
            @level2type = N'COLUMN',
            @level2name = N'ADR_updated_at';

        PRINT N'        [+] Column description added      : ADR_updated_at';

    END
    ELSE
    BEGIN

        SET @ADR_existing_description = NULL;


        SELECT
            @ADR_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'reference.Address')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'ADR_updated_at';


        IF @ADR_existing_description =
            @ADR_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : ADR_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : ADR_updated_at';
            PRINT N'            Expected                     : '
                + @ADR_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @ADR_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@ADR_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @ADR_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';