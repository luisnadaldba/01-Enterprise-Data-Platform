    PRINT N'    catalog.ProductCategory';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FOREIGN KEY: FK_PRDCT_PRD
    ==============================================================================*/

    DECLARE @PRDCT_FK_PRD_expected_name                sysname;
    DECLARE @PRDCT_FK_PRD_actual_name                  sysname;

    DECLARE @PRDCT_FK_PRD_actual_parent_table          nvarchar(517);
    DECLARE @PRDCT_FK_PRD_actual_parent_columns        nvarchar(4000);

    DECLARE @PRDCT_FK_PRD_actual_referenced_table      nvarchar(517);
    DECLARE @PRDCT_FK_PRD_actual_referenced_columns    nvarchar(4000);

    DECLARE @PRDCT_FK_PRD_actual_delete_action         nvarchar(60);
    DECLARE @PRDCT_FK_PRD_actual_update_action         nvarchar(60);

    DECLARE @PRDCT_FK_PRD_actual_is_disabled           bit;
    DECLARE @PRDCT_FK_PRD_actual_is_not_trusted        bit;

    DECLARE @PRDCT_FK_PRD_equivalent_name              sysname;
    DECLARE @PRDCT_FK_PRD_equivalent_delete_action     nvarchar(60);
    DECLARE @PRDCT_FK_PRD_equivalent_update_action     nvarchar(60);
    DECLARE @PRDCT_FK_PRD_equivalent_is_disabled       bit;
    DECLARE @PRDCT_FK_PRD_equivalent_is_not_trusted    bit;

    DECLARE @PRDCT_FK_PRD_conflict_parent              nvarchar(517);

    SET @PRDCT_FK_PRD_expected_name = N'FK_PRDCT_PRD';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductCategory', N'U') IS NULL
    BEGIN
        PRINT N'        [X] Foreign key dependency missing : catalog.ProductCategory';

        ;THROW 50390,
            N'Foreign key FK_PRDCT_PRD cannot be deployed because catalog.ProductCategory does not exist.',
            1;
    END;


    IF OBJECT_ID(N'catalog.Product', N'U') IS NULL
    BEGIN
        PRINT N'        [X] Foreign key dependency missing : catalog.Product';

        ;THROW 50391,
            N'Foreign key FK_PRDCT_PRD cannot be deployed because catalog.Product does not exist.',
            1;
    END;


    IF COL_LENGTH(N'catalog.ProductCategory', N'PRDCT_PRD_id') IS NULL
    BEGIN
        PRINT N'        [X] Foreign key column missing     : PRDCT_PRD_id';

        ;THROW 50392,
            N'Foreign key FK_PRDCT_PRD cannot be deployed because PRDCT_PRD_id does not exist.',
            1;
    END;


    IF COL_LENGTH(N'catalog.Product', N'PRD_id') IS NULL
    BEGIN
        PRINT N'        [X] Referenced column missing      : PRD_id';

        ;THROW 50393,
            N'Foreign key FK_PRDCT_PRD cannot be deployed because referenced column catalog.Product.PRD_id does not exist.',
            1;
    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PRDCT_PRD_id -> int NOT NULL
            PRD_id -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.Product')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND parent_column.name =
                N'PRDCT_PRD_id'

        AND referenced_column.name =
                N'PRD_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'int'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'int'
    )
    BEGIN
        PRINT N'        [X] Foreign key column mismatch    : PRDCT_PRD_id -> PRD_id';

        ;THROW 50394,
            N'Foreign key FK_PRDCT_PRD cannot be deployed because participating columns are incompatible.',
            1;
    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PRDCT_PRD';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PRDCT_FK_PRD_actual_name =
            fk.name,

        @PRDCT_FK_PRD_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @PRDCT_FK_PRD_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @PRDCT_FK_PRD_actual_delete_action =
            fk.delete_referential_action_desc,

        @PRDCT_FK_PRD_actual_update_action =
            fk.update_referential_action_desc,

        @PRDCT_FK_PRD_actual_is_disabled =
            fk.is_disabled,

        @PRDCT_FK_PRD_actual_is_not_trusted =
            fk.is_not_trusted,

        @PRDCT_FK_PRD_actual_parent_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), pc.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY fkc.constraint_column_id
                )

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        ),

        @PRDCT_FK_PRD_actual_referenced_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), rc.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY fkc.constraint_column_id
                )

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'catalog.ProductCategory')

    AND fk.name =
            @PRDCT_FK_PRD_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PRDCT_FK_PRD_actual_name IS NOT NULL
    BEGIN

        IF @PRDCT_FK_PRD_actual_parent_table =
                N'[catalog].[ProductCategory]'

        AND @PRDCT_FK_PRD_actual_parent_columns =
                N'PRDCT_PRD_id'

        AND @PRDCT_FK_PRD_actual_referenced_table =
                N'[catalog].[Product]'

        AND @PRDCT_FK_PRD_actual_referenced_columns =
                N'PRD_id'

        AND @PRDCT_FK_PRD_actual_delete_action =
                N'NO_ACTION'

        AND @PRDCT_FK_PRD_actual_update_action =
                N'NO_ACTION'

        AND @PRDCT_FK_PRD_actual_is_disabled = 0

        AND @PRDCT_FK_PRD_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PRDCT_PRD';
            PRINT N'            Column                          : PRDCT_PRD_id';
            PRINT N'            References                      : catalog.Product.PRD_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PRDCT_PRD';
            PRINT N'            Expected Table                  : catalog.ProductCategory';
            PRINT N'            Actual Table                    : '
                + COALESCE(@PRDCT_FK_PRD_actual_parent_table, N'<NULL>');
            PRINT N'            Expected Column                 : PRDCT_PRD_id';
            PRINT N'            Actual Column                   : '
                + COALESCE(REPLACE(@PRDCT_FK_PRD_actual_parent_columns, N'|', N', '), N'<NULL>');
            PRINT N'            Expected Reference              : catalog.Product.PRD_id';
            PRINT N'            Actual Reference Table         : '
                + COALESCE(@PRDCT_FK_PRD_actual_referenced_table, N'<NULL>');
            PRINT N'            Actual Reference Column        : '
                + COALESCE(REPLACE(@PRDCT_FK_PRD_actual_referenced_columns, N'|', N', '), N'<NULL>');
            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@PRDCT_FK_PRD_actual_delete_action, N'<NULL>');
            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@PRDCT_FK_PRD_actual_update_action, N'<NULL>');
            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE(CONVERT(nvarchar(1), @PRDCT_FK_PRD_actual_is_disabled), N'<NULL>');
            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE(CONVERT(nvarchar(1), @PRDCT_FK_PRD_actual_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END
    ELSE
    BEGIN

        /*==========================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==========================================================================*/

        SELECT TOP (1)
            @PRDCT_FK_PRD_equivalent_name =
                fk.name,

            @PRDCT_FK_PRD_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PRDCT_FK_PRD_equivalent_update_action =
                fk.update_referential_action_desc,

            @PRDCT_FK_PRD_equivalent_is_disabled =
                fk.is_disabled,

            @PRDCT_FK_PRD_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.Product')

        AND fk.name <>
                @PRDCT_FK_PRD_expected_name

        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id =
                    fk.object_id
        ) = 1

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'PRDCT_PRD_id'

            AND rc.name =
                    N'PRD_id'
        )

        ORDER BY fk.name;


        IF @PRDCT_FK_PRD_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';
            PRINT N'            Expected Name                  : FK_PRDCT_PRD';
            PRINT N'            Actual Name                    : '
                + @PRDCT_FK_PRD_equivalent_name;
            PRINT N'            Column                         : PRDCT_PRD_id';
            PRINT N'            References                     : catalog.Product.PRD_id';
            PRINT N'            ON DELETE                      : '
                + COALESCE(@PRDCT_FK_PRD_equivalent_delete_action, N'<NULL>');
            PRINT N'            ON UPDATE                      : '
                + COALESCE(@PRDCT_FK_PRD_equivalent_update_action, N'<NULL>');
            PRINT N'            Disabled                       : '
                + COALESCE(CONVERT(nvarchar(1), @PRDCT_FK_PRD_equivalent_is_disabled), N'<NULL>');
            PRINT N'            Not Trusted                    : '
                + COALESCE(CONVERT(nvarchar(1), @PRDCT_FK_PRD_equivalent_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            /*==========================================================================
                VALIDATE EXPECTED NAME IS NOT USED BY ANOTHER FK
            ==========================================================================*/

            IF OBJECT_ID(N'catalog.FK_PRDCT_PRD', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PRDCT_FK_PRD_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'catalog.FK_PRDCT_PRD', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_PRDCT_PRD';
                PRINT N'            Expected Table                  : catalog.ProductCategory';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@PRDCT_FK_PRD_conflict_parent, N'<UNKNOWN>');
                PRINT N'            Constraint was not created. Manual review is required.';

                ;THROW 50395,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==========================================================================
                CREATE FOREIGN KEY
            ==========================================================================*/

            ALTER TABLE catalog.ProductCategory
                WITH CHECK
                ADD CONSTRAINT FK_PRDCT_PRD
                FOREIGN KEY
                (
                    PRDCT_PRD_id
                )
                REFERENCES catalog.Product
                (
                    PRD_id
                );


            ALTER TABLE catalog.ProductCategory
                CHECK CONSTRAINT FK_PRDCT_PRD;


            PRINT N'        [+] Foreign key constraint added    : FK_PRDCT_PRD';
            PRINT N'            Column                          : PRDCT_PRD_id';
            PRINT N'            References                      : catalog.Product.PRD_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';

    /*==============================================================================
        FOREIGN KEY: FK_PRDCT_CTG
    ==============================================================================*/

    DECLARE @PRDCT_FK_CTG_expected_name                sysname;
    DECLARE @PRDCT_FK_CTG_actual_name                  sysname;

    DECLARE @PRDCT_FK_CTG_actual_parent_table          nvarchar(517);
    DECLARE @PRDCT_FK_CTG_actual_parent_columns        nvarchar(4000);

    DECLARE @PRDCT_FK_CTG_actual_referenced_table      nvarchar(517);
    DECLARE @PRDCT_FK_CTG_actual_referenced_columns    nvarchar(4000);

    DECLARE @PRDCT_FK_CTG_actual_delete_action         nvarchar(60);
    DECLARE @PRDCT_FK_CTG_actual_update_action         nvarchar(60);

    DECLARE @PRDCT_FK_CTG_actual_is_disabled           bit;
    DECLARE @PRDCT_FK_CTG_actual_is_not_trusted        bit;

    DECLARE @PRDCT_FK_CTG_equivalent_name              sysname;
    DECLARE @PRDCT_FK_CTG_equivalent_delete_action     nvarchar(60);
    DECLARE @PRDCT_FK_CTG_equivalent_update_action     nvarchar(60);
    DECLARE @PRDCT_FK_CTG_equivalent_is_disabled       bit;
    DECLARE @PRDCT_FK_CTG_equivalent_is_not_trusted    bit;

    DECLARE @PRDCT_FK_CTG_conflict_parent              nvarchar(517);

    SET @PRDCT_FK_CTG_expected_name = N'FK_PRDCT_CTG';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductCategory', N'U') IS NULL
    BEGIN
        PRINT N'        [X] Foreign key dependency missing : catalog.ProductCategory';

        ;THROW 50400,
            N'Foreign key FK_PRDCT_CTG cannot be deployed because catalog.ProductCategory does not exist.',
            1;
    END;


    IF OBJECT_ID(N'catalog.Category', N'U') IS NULL
    BEGIN
        PRINT N'        [X] Foreign key dependency missing : catalog.Category';

        ;THROW 50401,
            N'Foreign key FK_PRDCT_CTG cannot be deployed because catalog.Category does not exist.',
            1;
    END;


    IF COL_LENGTH(N'catalog.ProductCategory', N'PRDCT_CTG_id') IS NULL
    BEGIN
        PRINT N'        [X] Foreign key column missing     : PRDCT_CTG_id';

        ;THROW 50402,
            N'Foreign key FK_PRDCT_CTG cannot be deployed because PRDCT_CTG_id does not exist.',
            1;
    END;


    IF COL_LENGTH(N'catalog.Category', N'CTG_id') IS NULL
    BEGIN
        PRINT N'        [X] Referenced column missing      : CTG_id';

        ;THROW 50403,
            N'Foreign key FK_PRDCT_CTG cannot be deployed because referenced column catalog.Category.CTG_id does not exist.',
            1;
    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PRDCT_CTG_id -> smallint NOT NULL
            CTG_id -> smallint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.Category')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND parent_column.name =
                N'PRDCT_CTG_id'

        AND referenced_column.name =
                N'CTG_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'smallint'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'smallint'
    )
    BEGIN
        PRINT N'        [X] Foreign key column mismatch    : PRDCT_CTG_id -> CTG_id';

        ;THROW 50404,
            N'Foreign key FK_PRDCT_CTG cannot be deployed because participating columns are incompatible.',
            1;
    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PRDCT_CTG';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PRDCT_FK_CTG_actual_name =
            fk.name,

        @PRDCT_FK_CTG_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @PRDCT_FK_CTG_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @PRDCT_FK_CTG_actual_delete_action =
            fk.delete_referential_action_desc,

        @PRDCT_FK_CTG_actual_update_action =
            fk.update_referential_action_desc,

        @PRDCT_FK_CTG_actual_is_disabled =
            fk.is_disabled,

        @PRDCT_FK_CTG_actual_is_not_trusted =
            fk.is_not_trusted,

        @PRDCT_FK_CTG_actual_parent_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), pc.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY fkc.constraint_column_id
                )

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        ),

        @PRDCT_FK_CTG_actual_referenced_columns =
        (
            SELECT
                STRING_AGG
                (
                    CONVERT(nvarchar(max), rc.name),
                    N'|'
                )
                WITHIN GROUP
                (
                    ORDER BY fkc.constraint_column_id
                )

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'catalog.ProductCategory')

    AND fk.name =
            @PRDCT_FK_CTG_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PRDCT_FK_CTG_actual_name IS NOT NULL
    BEGIN

        IF @PRDCT_FK_CTG_actual_parent_table =
                N'[catalog].[ProductCategory]'

        AND @PRDCT_FK_CTG_actual_parent_columns =
                N'PRDCT_CTG_id'

        AND @PRDCT_FK_CTG_actual_referenced_table =
                N'[catalog].[Category]'

        AND @PRDCT_FK_CTG_actual_referenced_columns =
                N'CTG_id'

        AND @PRDCT_FK_CTG_actual_delete_action =
                N'NO_ACTION'

        AND @PRDCT_FK_CTG_actual_update_action =
                N'NO_ACTION'

        AND @PRDCT_FK_CTG_actual_is_disabled = 0

        AND @PRDCT_FK_CTG_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PRDCT_CTG';
            PRINT N'            Column                          : PRDCT_CTG_id';
            PRINT N'            References                      : catalog.Category.CTG_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PRDCT_CTG';
            PRINT N'            Expected Table                  : catalog.ProductCategory';
            PRINT N'            Actual Table                    : '
                + COALESCE(@PRDCT_FK_CTG_actual_parent_table, N'<NULL>');
            PRINT N'            Expected Column                 : PRDCT_CTG_id';
            PRINT N'            Actual Column                   : '
                + COALESCE(REPLACE(@PRDCT_FK_CTG_actual_parent_columns, N'|', N', '), N'<NULL>');
            PRINT N'            Expected Reference              : catalog.Category.CTG_id';
            PRINT N'            Actual Reference Table         : '
                + COALESCE(@PRDCT_FK_CTG_actual_referenced_table, N'<NULL>');
            PRINT N'            Actual Reference Column        : '
                + COALESCE(REPLACE(@PRDCT_FK_CTG_actual_referenced_columns, N'|', N', '), N'<NULL>');
            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@PRDCT_FK_CTG_actual_delete_action, N'<NULL>');
            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@PRDCT_FK_CTG_actual_update_action, N'<NULL>');
            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE(CONVERT(nvarchar(1), @PRDCT_FK_CTG_actual_is_disabled), N'<NULL>');
            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE(CONVERT(nvarchar(1), @PRDCT_FK_CTG_actual_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END
    ELSE
    BEGIN

        /*==========================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==========================================================================*/

        SELECT TOP (1)
            @PRDCT_FK_CTG_equivalent_name =
                fk.name,

            @PRDCT_FK_CTG_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PRDCT_FK_CTG_equivalent_update_action =
                fk.update_referential_action_desc,

            @PRDCT_FK_CTG_equivalent_is_disabled =
                fk.is_disabled,

            @PRDCT_FK_CTG_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.ProductCategory')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.Category')

        AND fk.name <>
                @PRDCT_FK_CTG_expected_name

        AND fk.delete_referential_action = 0
        AND fk.update_referential_action = 0

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id =
                    fk.object_id
        ) = 1

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_key_columns AS fkc

            INNER JOIN sys.columns AS pc
                ON  pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON  rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'PRDCT_CTG_id'

            AND rc.name =
                    N'CTG_id'
        )

        ORDER BY fk.name;


        IF @PRDCT_FK_CTG_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';
            PRINT N'            Expected Name                  : FK_PRDCT_CTG';
            PRINT N'            Actual Name                    : '
                + @PRDCT_FK_CTG_equivalent_name;
            PRINT N'            Column                         : PRDCT_CTG_id';
            PRINT N'            References                     : catalog.Category.CTG_id';
            PRINT N'            ON DELETE                      : '
                + COALESCE(@PRDCT_FK_CTG_equivalent_delete_action, N'<NULL>');
            PRINT N'            ON UPDATE                      : '
                + COALESCE(@PRDCT_FK_CTG_equivalent_update_action, N'<NULL>');
            PRINT N'            Disabled                       : '
                + COALESCE(CONVERT(nvarchar(1), @PRDCT_FK_CTG_equivalent_is_disabled), N'<NULL>');
            PRINT N'            Not Trusted                    : '
                + COALESCE(CONVERT(nvarchar(1), @PRDCT_FK_CTG_equivalent_is_not_trusted), N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            /*==========================================================================
                VALIDATE EXPECTED NAME IS NOT USED BY ANOTHER FK
            ==========================================================================*/

            IF OBJECT_ID(N'catalog.FK_PRDCT_CTG', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PRDCT_FK_CTG_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'catalog.FK_PRDCT_CTG', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_PRDCT_CTG';
                PRINT N'            Expected Table                  : catalog.ProductCategory';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@PRDCT_FK_CTG_conflict_parent, N'<UNKNOWN>');
                PRINT N'            Constraint was not created. Manual review is required.';

                ;THROW 50405,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==========================================================================
                CREATE FOREIGN KEY
            ==========================================================================*/

            ALTER TABLE catalog.ProductCategory
                WITH CHECK
                ADD CONSTRAINT FK_PRDCT_CTG
                FOREIGN KEY
                (
                    PRDCT_CTG_id
                )
                REFERENCES catalog.Category
                (
                    CTG_id
                );


            ALTER TABLE catalog.ProductCategory
                CHECK CONSTRAINT FK_PRDCT_CTG;


            PRINT N'        [+] Foreign key constraint added    : FK_PRDCT_CTG';
            PRINT N'            Column                          : PRDCT_CTG_id';
            PRINT N'            References                      : catalog.Category.CTG_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';