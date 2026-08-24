    PRINT N'';
    PRINT N'    ● customer.CustomerContact';
    PRINT N'';

    DECLARE @CSTCN_expected_description nvarchar(4000);
    DECLARE @CSTCN_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
        N'Maintains telephone contact information associated with identified customers in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact';

        PRINT N'        [+] Table description added       : customer.CustomerContact';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : customer.CustomerContact';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : customer.CustomerContact';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCN_id
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
        N'Primary key of customer.CustomerContact.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact',
            @level2type = N'COLUMN',
            @level2name = N'CSTCN_id';

        PRINT N'        [+] Column description added      : CSTCN_id';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_id';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCN_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCN_id';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCN_CST_id
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
        N'Foreign key referencing customer.Customer.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_CST_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact',
            @level2type = N'COLUMN',
            @level2name = N'CSTCN_CST_id';

        PRINT N'        [+] Column description added      : CSTCN_CST_id';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_CST_id';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCN_CST_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCN_CST_id';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCN_CTP_id
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
        N'Foreign key referencing reference.ContactType.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_CTP_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact',
            @level2type = N'COLUMN',
            @level2name = N'CSTCN_CTP_id';

        PRINT N'        [+] Column description added      : CSTCN_CTP_id';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_CTP_id';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCN_CTP_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCN_CTP_id';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCN_value
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
        N'Stores the telephone number without presentation formatting.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_value'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact',
            @level2type = N'COLUMN',
            @level2name = N'CSTCN_value';

        PRINT N'        [+] Column description added      : CSTCN_value';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_value';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCN_value';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCN_value';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCN_is_primary
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
        N'Indicates whether the contact is the primary active telephone contact for the customer.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_is_primary'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact',
            @level2type = N'COLUMN',
            @level2name = N'CSTCN_is_primary';

        PRINT N'        [+] Column description added      : CSTCN_is_primary';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_is_primary';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCN_is_primary';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCN_is_primary';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCN_is_active
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
        N'Indicates whether the customer contact is currently active and available for use.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_is_active'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact',
            @level2type = N'COLUMN',
            @level2name = N'CSTCN_is_active';

        PRINT N'        [+] Column description added      : CSTCN_is_active';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_is_active';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCN_is_active';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCN_is_active';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCN_created_at
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
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
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact',
            @level2type = N'COLUMN',
            @level2name = N'CSTCN_created_at';

        PRINT N'        [+] Column description added      : CSTCN_created_at';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_created_at';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCN_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCN_created_at';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: CSTCN_updated_at
    ----------------------------------------------------------------------*/

    SET @CSTCN_expected_description =
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
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @CSTCN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'customer',
            @level1type = N'TABLE',
            @level1name = N'CustomerContact',
            @level2type = N'COLUMN',
            @level2name = N'CSTCN_updated_at';

        PRINT N'        [+] Column description added      : CSTCN_updated_at';

    END
    ELSE
    BEGIN

        SET @CSTCN_existing_description = NULL;


        SELECT
            @CSTCN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'CSTCN_updated_at';


        IF @CSTCN_existing_description =
            @CSTCN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : CSTCN_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : CSTCN_updated_at';
            PRINT N'            Expected                     : '
                + @CSTCN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @CSTCN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@CSTCN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @CSTCN_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';