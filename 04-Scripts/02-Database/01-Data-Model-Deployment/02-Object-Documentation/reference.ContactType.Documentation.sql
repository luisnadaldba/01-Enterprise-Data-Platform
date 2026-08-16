    PRINT N'    reference.ContactType';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @CTP_expected_description nvarchar(4000);
    DECLARE @CTP_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CTP_expected_description =
        N'Maintains reusable telephone contact type values shared across Atlas Commerce domains.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'ContactType';

        PRINT N'        [+] Table description added       : reference.ContactType';

    END
    ELSE
    BEGIN

        SET @CTP_existing_description = NULL;

        SELECT
            @CTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @CTP_existing_description = @CTP_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : reference.ContactType';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : reference.ContactType';
            PRINT N'            Expected                     : '
                + @CTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTP_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CTP_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CTP_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTP_id
    ----------------------------------------------------------------------*/

    SET @CTP_expected_description =
        N'Primary key of reference.ContactType.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTP_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'ContactType',
            @level2type = N'COLUMN',
            @level2name = N'CTP_id';

        PRINT N'        [+] Column description added      : CTP_id';

    END
    ELSE
    BEGIN

        SET @CTP_existing_description = NULL;

        SELECT
            @CTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTP_id';

        IF @CTP_existing_description = @CTP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTP_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTP_id';
            PRINT N'            Expected                     : '
                + @CTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTP_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTP_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTP_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTP_name
    ----------------------------------------------------------------------*/

    SET @CTP_expected_description =
        N'Stores the controlled name used to identify the telephone contact type.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTP_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'ContactType',
            @level2type = N'COLUMN',
            @level2name = N'CTP_name';

        PRINT N'        [+] Column description added      : CTP_name';

    END
    ELSE
    BEGIN

        SET @CTP_existing_description = NULL;

        SELECT
            @CTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTP_name';

        IF @CTP_existing_description = @CTP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTP_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTP_name';
            PRINT N'            Expected                     : '
                + @CTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTP_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTP_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTP_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTP_created_at
    ----------------------------------------------------------------------*/

    SET @CTP_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTP_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'ContactType',
            @level2type = N'COLUMN',
            @level2name = N'CTP_created_at';

        PRINT N'        [+] Column description added      : CTP_created_at';

    END
    ELSE
    BEGIN

        SET @CTP_existing_description = NULL;

        SELECT
            @CTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTP_created_at';

        IF @CTP_existing_description = @CTP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTP_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTP_created_at';
            PRINT N'            Expected                     : '
                + @CTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTP_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTP_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTP_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CTP_updated_at
    ----------------------------------------------------------------------*/

    SET @CTP_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTP_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CTP_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'reference',
            @level1type = N'TABLE',
            @level1name = N'ContactType',
            @level2type = N'COLUMN',
            @level2name = N'CTP_updated_at';

        PRINT N'        [+] Column description added      : CTP_updated_at';

    END
    ELSE
    BEGIN

        SET @CTP_existing_description = NULL;

        SELECT
            @CTP_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'reference.ContactType')
        AND ep.name = N'MS_Description'
        AND c.name = N'CTP_updated_at';

        IF @CTP_existing_description = @CTP_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CTP_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CTP_updated_at';
            PRINT N'            Expected                     : '
                + @CTP_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CTP_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@CTP_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @CTP_existing_description
                END;

        END;

    END;


    PRINT N'';