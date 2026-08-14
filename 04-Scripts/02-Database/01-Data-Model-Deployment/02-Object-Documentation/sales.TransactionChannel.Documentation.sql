    PRINT N'    sales.TransactionChannel';
    PRINT N'    --------------------------------------------------------------------------';

    DECLARE @TRNCH_expected_description nvarchar(4000);
    DECLARE @TRNCH_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @TRNCH_expected_description =
        N'Maintains the authoritative set of transaction channels used by the sales transactional model.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNCH_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionChannel';

        PRINT N'        [+] Table description added       : sales.TransactionChannel';

    END
    ELSE
    BEGIN

        SET @TRNCH_existing_description = NULL;

        SELECT
            @TRNCH_existing_description =
                CONVERT(nvarchar(4000), ep.value)
        FROM sys.extended_properties AS ep
        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.minor_id = 0
        AND ep.name = N'MS_Description';

        IF @TRNCH_existing_description = @TRNCH_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : sales.TransactionChannel';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : sales.TransactionChannel';
            PRINT N'            Expected                     : '
                + @TRNCH_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNCH_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNCH_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNCH_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNCH_id
    ----------------------------------------------------------------------*/

    SET @TRNCH_expected_description =
        N'Primary key of sales.TransactionChannel.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNCH_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionChannel',
            @level2type = N'COLUMN',
            @level2name = N'TRNCH_id';

        PRINT N'        [+] Column description added      : TRNCH_id';

    END
    ELSE
    BEGIN

        SET @TRNCH_existing_description = NULL;

        SELECT
            @TRNCH_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_id';

        IF @TRNCH_existing_description = @TRNCH_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNCH_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNCH_id';
            PRINT N'            Expected                     : '
                + @TRNCH_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNCH_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@TRNCH_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @TRNCH_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNCH_code
    ----------------------------------------------------------------------*/

    SET @TRNCH_expected_description =
        N'Stores the stable system code that uniquely identifies the transaction channel.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_code'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNCH_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionChannel',
            @level2type = N'COLUMN',
            @level2name = N'TRNCH_code';

        PRINT N'        [+] Column description added      : TRNCH_code';

    END
    ELSE
    BEGIN

        SET @TRNCH_existing_description = NULL;

        SELECT
            @TRNCH_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_code';

        IF @TRNCH_existing_description = @TRNCH_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNCH_code';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNCH_code';
            PRINT N'            Expected                     : '
                + @TRNCH_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNCH_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@TRNCH_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @TRNCH_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNCH_name
    ----------------------------------------------------------------------*/

    SET @TRNCH_expected_description =
        N'Provides the business description associated with the transaction channel code.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNCH_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionChannel',
            @level2type = N'COLUMN',
            @level2name = N'TRNCH_name';

        PRINT N'        [+] Column description added      : TRNCH_name';

    END
    ELSE
    BEGIN

        SET @TRNCH_existing_description = NULL;

        SELECT
            @TRNCH_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_name';

        IF @TRNCH_existing_description = @TRNCH_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNCH_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNCH_name';
            PRINT N'            Expected                     : '
                + @TRNCH_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNCH_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@TRNCH_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @TRNCH_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNCH_is_active
    ----------------------------------------------------------------------*/

    SET @TRNCH_expected_description =
        N'Indicates whether the transaction channel is currently available for operational use while preserving inactive channels for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNCH_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionChannel',
            @level2type = N'COLUMN',
            @level2name = N'TRNCH_is_active';

        PRINT N'        [+] Column description added      : TRNCH_is_active';

    END
    ELSE
    BEGIN

        SET @TRNCH_existing_description = NULL;

        SELECT
            @TRNCH_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_is_active';

        IF @TRNCH_existing_description = @TRNCH_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNCH_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNCH_is_active';
            PRINT N'            Expected                     : '
                + @TRNCH_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNCH_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@TRNCH_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @TRNCH_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNCH_created_at
    ----------------------------------------------------------------------*/

    SET @TRNCH_expected_description =
        N'Records the date and time when the row was initially created.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNCH_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionChannel',
            @level2type = N'COLUMN',
            @level2name = N'TRNCH_created_at';

        PRINT N'        [+] Column description added      : TRNCH_created_at';

    END
    ELSE
    BEGIN

        SET @TRNCH_existing_description = NULL;

        SELECT
            @TRNCH_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_created_at';

        IF @TRNCH_existing_description = @TRNCH_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNCH_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNCH_created_at';
            PRINT N'            Expected                     : '
                + @TRNCH_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNCH_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@TRNCH_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @TRNCH_existing_description
                END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNCH_updated_at
    ----------------------------------------------------------------------*/

    SET @TRNCH_expected_description =
        N'Records the date and time of the most recent meaningful modification to the row.';

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNCH_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionChannel',
            @level2type = N'COLUMN',
            @level2name = N'TRNCH_updated_at';

        PRINT N'        [+] Column description added      : TRNCH_updated_at';

    END
    ELSE
    BEGIN

        SET @TRNCH_existing_description = NULL;

        SELECT
            @TRNCH_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1
        AND ep.major_id = OBJECT_ID(N'sales.TransactionChannel')
        AND ep.name = N'MS_Description'
        AND c.name = N'TRNCH_updated_at';

        IF @TRNCH_existing_description = @TRNCH_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNCH_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNCH_updated_at';
            PRINT N'            Expected                     : '
                + @TRNCH_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNCH_existing_description IS NULL THEN N'<NULL>'
                    WHEN LEN(@TRNCH_existing_description) = 0 THEN N'<EMPTY>'
                    ELSE @TRNCH_existing_description
                END;

        END;

    END;


    PRINT N'';