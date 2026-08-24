    PRINT N'';
    PRINT N'    ● metadata.TablePrefix';
    PRINT N'';

    DECLARE @PFX_expected_description nvarchar(4000);
    DECLARE @PFX_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @PFX_expected_description =
        N'Maintains the authoritative registry of table prefixes used to enforce naming consistency, prevent prefix reuse, and preserve prefix assignment history across Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PFX_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'metadata',
            @level1type = N'TABLE',
            @level1name = N'TablePrefix';

        PRINT N'        [+] Table description added       : metadata.TablePrefix';

    END
    ELSE
    BEGIN

        SET @PFX_existing_description = NULL;


        SELECT
            @PFX_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @PFX_existing_description =
            @PFX_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : metadata.TablePrefix';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : metadata.TablePrefix';
            PRINT N'            Expected                     : '
                + @PFX_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PFX_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PFX_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PFX_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PFX_id
    ----------------------------------------------------------------------*/

    SET @PFX_expected_description =
        N'Primary key of metadata.TablePrefix.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PFX_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'metadata',
            @level1type = N'TABLE',
            @level1name = N'TablePrefix',
            @level2type = N'COLUMN',
            @level2name = N'PFX_id';

        PRINT N'        [+] Column description added      : PFX_id';

    END
    ELSE
    BEGIN

        SET @PFX_existing_description = NULL;


        SELECT
            @PFX_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_id';


        IF @PFX_existing_description =
            @PFX_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PFX_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PFX_id';
            PRINT N'            Expected                     : '
                + @PFX_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PFX_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PFX_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PFX_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PFX_schema_name
    ----------------------------------------------------------------------*/

    SET @PFX_expected_description =
        N'Stores the schema name of the table associated with the registered prefix.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_schema_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PFX_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'metadata',
            @level1type = N'TABLE',
            @level1name = N'TablePrefix',
            @level2type = N'COLUMN',
            @level2name = N'PFX_schema_name';

        PRINT N'        [+] Column description added      : PFX_schema_name';

    END
    ELSE
    BEGIN

        SET @PFX_existing_description = NULL;


        SELECT
            @PFX_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_schema_name';


        IF @PFX_existing_description =
            @PFX_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PFX_schema_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PFX_schema_name';
            PRINT N'            Expected                     : '
                + @PFX_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PFX_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PFX_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PFX_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PFX_table_name
    ----------------------------------------------------------------------*/

    SET @PFX_expected_description =
        N'Stores the table name associated with the registered prefix within its owning schema.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_table_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PFX_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'metadata',
            @level1type = N'TABLE',
            @level1name = N'TablePrefix',
            @level2type = N'COLUMN',
            @level2name = N'PFX_table_name';

        PRINT N'        [+] Column description added      : PFX_table_name';

    END
    ELSE
    BEGIN

        SET @PFX_existing_description = NULL;


        SELECT
            @PFX_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_table_name';


        IF @PFX_existing_description =
            @PFX_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PFX_table_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PFX_table_name';
            PRINT N'            Expected                     : '
                + @PFX_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PFX_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PFX_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PFX_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PFX_prefix
    ----------------------------------------------------------------------*/

    SET @PFX_expected_description =
        N'Stores the unique and permanently reserved prefix assigned to the registered table and used by its column naming convention.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_prefix'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PFX_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'metadata',
            @level1type = N'TABLE',
            @level1name = N'TablePrefix',
            @level2type = N'COLUMN',
            @level2name = N'PFX_prefix';

        PRINT N'        [+] Column description added      : PFX_prefix';

    END
    ELSE
    BEGIN

        SET @PFX_existing_description = NULL;


        SELECT
            @PFX_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_prefix';


        IF @PFX_existing_description =
            @PFX_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PFX_prefix';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PFX_prefix';
            PRINT N'            Expected                     : '
                + @PFX_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PFX_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PFX_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PFX_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PFX_is_active
    ----------------------------------------------------------------------*/

    SET @PFX_expected_description =
        N'Indicates whether the registered table prefix is currently active while preserving inactive assignments for historical governance and preventing prefix reuse.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PFX_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'metadata',
            @level1type = N'TABLE',
            @level1name = N'TablePrefix',
            @level2type = N'COLUMN',
            @level2name = N'PFX_is_active';

        PRINT N'        [+] Column description added      : PFX_is_active';

    END
    ELSE
    BEGIN

        SET @PFX_existing_description = NULL;


        SELECT
            @PFX_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_is_active';


        IF @PFX_existing_description =
            @PFX_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PFX_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PFX_is_active';
            PRINT N'            Expected                     : '
                + @PFX_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PFX_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PFX_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PFX_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PFX_created_at
    ----------------------------------------------------------------------*/

    SET @PFX_expected_description =
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
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PFX_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'metadata',
            @level1type = N'TABLE',
            @level1name = N'TablePrefix',
            @level2type = N'COLUMN',
            @level2name = N'PFX_created_at';

        PRINT N'        [+] Column description added      : PFX_created_at';

    END
    ELSE
    BEGIN

        SET @PFX_existing_description = NULL;


        SELECT
            @PFX_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_created_at';


        IF @PFX_existing_description =
            @PFX_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PFX_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PFX_created_at';
            PRINT N'            Expected                     : '
                + @PFX_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PFX_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PFX_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PFX_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: PFX_updated_at
    ----------------------------------------------------------------------*/

    SET @PFX_expected_description =
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
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @PFX_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'metadata',
            @level1type = N'TABLE',
            @level1name = N'TablePrefix',
            @level2type = N'COLUMN',
            @level2name = N'PFX_updated_at';

        PRINT N'        [+] Column description added      : PFX_updated_at';

    END
    ELSE
    BEGIN

        SET @PFX_existing_description = NULL;


        SELECT
            @PFX_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'metadata.TablePrefix')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'PFX_updated_at';


        IF @PFX_existing_description =
            @PFX_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : PFX_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : PFX_updated_at';
            PRINT N'            Expected                     : '
                + @PFX_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @PFX_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@PFX_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @PFX_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';