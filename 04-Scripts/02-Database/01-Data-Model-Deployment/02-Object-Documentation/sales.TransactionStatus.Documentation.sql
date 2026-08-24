    PRINT N'';
    PRINT N'    ● sales.TransactionStatus';
    PRINT N'';


    DECLARE @TRNST_expected_description nvarchar(4000);
    DECLARE @TRNST_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @TRNST_expected_description =
        N'Maintains the controlled transaction statuses used by the Atlas Commerce sales transactional model.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionStatus';

        PRINT N'        [+] Table description added       : sales.TransactionStatus';

    END
    ELSE
    BEGIN

        SET @TRNST_existing_description = NULL;


        SELECT
            @TRNST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @TRNST_existing_description =
            @TRNST_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : sales.TransactionStatus';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : sales.TransactionStatus';
            PRINT N'            Expected                     : '
                + @TRNST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNST_id
    ----------------------------------------------------------------------*/

    SET @TRNST_expected_description =
        N'Primary key of sales.TransactionStatus.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionStatus',
            @level2type = N'COLUMN',
            @level2name = N'TRNST_id';

        PRINT N'        [+] Column description added      : TRNST_id';

    END
    ELSE
    BEGIN

        SET @TRNST_existing_description = NULL;


        SELECT
            @TRNST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_id';


        IF @TRNST_existing_description =
            @TRNST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNST_id';
            PRINT N'            Expected                     : '
                + @TRNST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNST_code
    ----------------------------------------------------------------------*/

    SET @TRNST_expected_description =
        N'Stores the stable system code that uniquely identifies the transaction status.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_code'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionStatus',
            @level2type = N'COLUMN',
            @level2name = N'TRNST_code';

        PRINT N'        [+] Column description added      : TRNST_code';

    END
    ELSE
    BEGIN

        SET @TRNST_existing_description = NULL;


        SELECT
            @TRNST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_code';


        IF @TRNST_existing_description =
            @TRNST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNST_code';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNST_code';
            PRINT N'            Expected                     : '
                + @TRNST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNST_name
    ----------------------------------------------------------------------*/

    SET @TRNST_expected_description =
        N'Stores the human-readable name of the transaction status for presentation purposes.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_name'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionStatus',
            @level2type = N'COLUMN',
            @level2name = N'TRNST_name';

        PRINT N'        [+] Column description added      : TRNST_name';

    END
    ELSE
    BEGIN

        SET @TRNST_existing_description = NULL;


        SELECT
            @TRNST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_name';


        IF @TRNST_existing_description =
            @TRNST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNST_name';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNST_name';
            PRINT N'            Expected                     : '
                + @TRNST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNST_is_active
    ----------------------------------------------------------------------*/

    SET @TRNST_expected_description =
        N'Indicates whether the transaction status is currently available for operational use while preserving inactive statuses for historical integrity.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionStatus',
            @level2type = N'COLUMN',
            @level2name = N'TRNST_is_active';

        PRINT N'        [+] Column description added      : TRNST_is_active';

    END
    ELSE
    BEGIN

        SET @TRNST_existing_description = NULL;


        SELECT
            @TRNST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_is_active';


        IF @TRNST_existing_description =
            @TRNST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNST_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNST_is_active';
            PRINT N'            Expected                     : '
                + @TRNST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNST_created_at
    ----------------------------------------------------------------------*/

    SET @TRNST_expected_description =
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
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionStatus',
            @level2type = N'COLUMN',
            @level2name = N'TRNST_created_at';

        PRINT N'        [+] Column description added      : TRNST_created_at';

    END
    ELSE
    BEGIN

        SET @TRNST_existing_description = NULL;


        SELECT
            @TRNST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_created_at';


        IF @TRNST_existing_description =
            @TRNST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNST_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNST_created_at';
            PRINT N'            Expected                     : '
                + @TRNST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNST_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: TRNST_updated_at
    ----------------------------------------------------------------------*/

    SET @TRNST_expected_description =
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
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @TRNST_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'sales',
            @level1type = N'TABLE',
            @level1name = N'TransactionStatus',
            @level2type = N'COLUMN',
            @level2name = N'TRNST_updated_at';

        PRINT N'        [+] Column description added      : TRNST_updated_at';

    END
    ELSE
    BEGIN

        SET @TRNST_existing_description = NULL;


        SELECT
            @TRNST_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'TRNST_updated_at';


        IF @TRNST_existing_description =
            @TRNST_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : TRNST_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : TRNST_updated_at';
            PRINT N'            Expected                     : '
                + @TRNST_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @TRNST_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@TRNST_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @TRNST_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';