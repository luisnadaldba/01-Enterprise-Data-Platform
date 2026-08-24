    PRINT N'';
    PRINT N'    ● inventory.InventoryMovementNote';
    PRINT N'';

    DECLARE @INVMN_expected_description nvarchar(4000);
    DECLARE @INVMN_existing_description nvarchar(4000);


    /*----------------------------------------------------------------------
        TABLE DESCRIPTION
    ----------------------------------------------------------------------*/

    SET @INVMN_expected_description =
        N'Maintains optional free-text notes associated with inventory movement events in Atlas Commerce.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementNote';

        PRINT N'        [+] Table description added       : inventory.InventoryMovementNote';

    END
    ELSE
    BEGIN

        SET @INVMN_existing_description = NULL;


        SELECT
            @INVMN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.minor_id = 0

        AND ep.name =
                N'MS_Description';


        IF @INVMN_existing_description =
            @INVMN_expected_description
        BEGIN

            PRINT N'        [•] Table description validated   : inventory.InventoryMovementNote';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Table description mismatch    : inventory.InventoryMovementNote';
            PRINT N'            Expected                     : '
                + @INVMN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMN_id
    ----------------------------------------------------------------------*/

    SET @INVMN_expected_description =
        N'Primary key of inventory.InventoryMovementNote.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementNote',
            @level2type = N'COLUMN',
            @level2name = N'INVMN_id';

        PRINT N'        [+] Column description added      : INVMN_id';

    END
    ELSE
    BEGIN

        SET @INVMN_existing_description = NULL;


        SELECT
            @INVMN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_id';


        IF @INVMN_existing_description =
            @INVMN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMN_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMN_id';
            PRINT N'            Expected                     : '
                + @INVMN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMN_INVMV_id
    ----------------------------------------------------------------------*/

    SET @INVMN_expected_description =
        N'Foreign key referencing inventory.InventoryMovement.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_INVMV_id'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementNote',
            @level2type = N'COLUMN',
            @level2name = N'INVMN_INVMV_id';

        PRINT N'        [+] Column description added      : INVMN_INVMV_id';

    END
    ELSE
    BEGIN

        SET @INVMN_existing_description = NULL;


        SELECT
            @INVMN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_INVMV_id';


        IF @INVMN_existing_description =
            @INVMN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMN_INVMV_id';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMN_INVMV_id';
            PRINT N'            Expected                     : '
                + @INVMN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMN_note
    ----------------------------------------------------------------------*/

    SET @INVMN_expected_description =
        N'Stores optional free-text operational context associated with the inventory movement without replacing its structured reason classification.';

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_note'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementNote',
            @level2type = N'COLUMN',
            @level2name = N'INVMN_note';

        PRINT N'        [+] Column description added      : INVMN_note';

    END
    ELSE
    BEGIN

        SET @INVMN_existing_description = NULL;


        SELECT
            @INVMN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_note';


        IF @INVMN_existing_description =
            @INVMN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMN_note';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMN_note';
            PRINT N'            Expected                     : '
                + @INVMN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMN_created_at
    ----------------------------------------------------------------------*/

    SET @INVMN_expected_description =
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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_created_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementNote',
            @level2type = N'COLUMN',
            @level2name = N'INVMN_created_at';

        PRINT N'        [+] Column description added      : INVMN_created_at';

    END
    ELSE
    BEGIN

        SET @INVMN_existing_description = NULL;


        SELECT
            @INVMN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_created_at';


        IF @INVMN_existing_description =
            @INVMN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMN_created_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMN_created_at';
            PRINT N'            Expected                     : '
                + @INVMN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMN_existing_description
                  END;

        END;

    END;


    /*----------------------------------------------------------------------
        COLUMN DESCRIPTION: INVMN_updated_at
    ----------------------------------------------------------------------*/

    SET @INVMN_expected_description =
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
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_updated_at'
    )
    BEGIN

        EXEC sys.sp_addextendedproperty
            @name = N'MS_Description',
            @value = @INVMN_expected_description,
            @level0type = N'SCHEMA',
            @level0name = N'inventory',
            @level1type = N'TABLE',
            @level1name = N'InventoryMovementNote',
            @level2type = N'COLUMN',
            @level2name = N'INVMN_updated_at';

        PRINT N'        [+] Column description added      : INVMN_updated_at';

    END
    ELSE
    BEGIN

        SET @INVMN_existing_description = NULL;


        SELECT
            @INVMN_existing_description =
                CONVERT(nvarchar(4000), ep.value)

        FROM sys.extended_properties AS ep

        INNER JOIN sys.columns AS c
            ON  c.object_id = ep.major_id
            AND c.column_id = ep.minor_id

        WHERE ep.class = 1

        AND ep.major_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND ep.name =
                N'MS_Description'

        AND c.name =
                N'INVMN_updated_at';


        IF @INVMN_existing_description =
            @INVMN_expected_description
        BEGIN

            PRINT N'        [•] Column description validated  : INVMN_updated_at';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Column description mismatch   : INVMN_updated_at';
            PRINT N'            Expected                     : '
                + @INVMN_expected_description;
            PRINT N'            Actual                       : '
                + CASE
                    WHEN @INVMN_existing_description IS NULL
                        THEN N'<NULL>'
                    WHEN LEN(@INVMN_existing_description) = 0
                        THEN N'<EMPTY>'
                    ELSE @INVMN_existing_description
                  END;

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';