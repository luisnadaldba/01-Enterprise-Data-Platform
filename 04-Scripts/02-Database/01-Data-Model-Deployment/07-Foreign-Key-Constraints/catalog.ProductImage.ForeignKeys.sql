    PRINT N'';
    PRINT N'    ● catalog.ProductImage';
    PRINT N'';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @PRDIM_FK_expected_name                sysname;
    DECLARE @PRDIM_FK_actual_name                  sysname;

    DECLARE @PRDIM_FK_actual_parent_table          nvarchar(517);
    DECLARE @PRDIM_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PRDIM_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PRDIM_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PRDIM_FK_actual_delete_action         nvarchar(60);
    DECLARE @PRDIM_FK_actual_update_action         nvarchar(60);

    DECLARE @PRDIM_FK_actual_is_disabled           bit;
    DECLARE @PRDIM_FK_actual_is_not_trusted        bit;

    DECLARE @PRDIM_FK_equivalent_name              sysname;
    DECLARE @PRDIM_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PRDIM_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PRDIM_FK_equivalent_is_disabled       bit;
    DECLARE @PRDIM_FK_equivalent_is_not_trusted    bit;

    DECLARE @PRDIM_FK_conflict_parent              nvarchar(517);


    SET @PRDIM_FK_expected_name = N'FK_PRDIM_PRD';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductImage', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductImage';

        ;THROW 50440,
            N'Foreign key FK_PRDIM_PRD cannot be deployed because catalog.ProductImage does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.Product', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.Product';

        ;THROW 50441,
            N'Foreign key FK_PRDIM_PRD cannot be deployed because catalog.Product does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductImage', N'PRDIM_PRD_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PRDIM_PRD_id';

        ;THROW 50442,
            N'Foreign key FK_PRDIM_PRD cannot be deployed because PRDIM_PRD_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.Product', N'PRD_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PRD_id';

        ;THROW 50443,
            N'Foreign key FK_PRDIM_PRD cannot be deployed because referenced column catalog.Product.PRD_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PRDIM_PRD_id -> int NOT NULL
            PRD_id       -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.Product')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND parent_column.name =
                N'PRDIM_PRD_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PRDIM_PRD_id -> PRD_id';

        ;THROW 50444,
            N'Foreign key FK_PRDIM_PRD cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PRDIM_PRD';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @PRDIM_FK_actual_name =
            fk.name,

        @PRDIM_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PRDIM_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PRDIM_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PRDIM_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PRDIM_FK_actual_is_disabled =
            fk.is_disabled,

        @PRDIM_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PRDIM_FK_actual_parent_columns =
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

        @PRDIM_FK_actual_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductImage')

    AND fk.name =
            @PRDIM_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @PRDIM_FK_actual_name IS NOT NULL
    BEGIN

        IF @PRDIM_FK_actual_parent_table =
                N'[catalog].[ProductImage]'

        AND @PRDIM_FK_actual_parent_columns =
                N'PRDIM_PRD_id'

        AND @PRDIM_FK_actual_referenced_table =
                N'[catalog].[Product]'

        AND @PRDIM_FK_actual_referenced_columns =
                N'PRD_id'

        AND @PRDIM_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PRDIM_FK_actual_update_action =
                N'NO_ACTION'

        AND @PRDIM_FK_actual_is_disabled = 0

        AND @PRDIM_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PRDIM_PRD';
            PRINT N'            Column                          : PRDIM_PRD_id';
            PRINT N'            References                      : catalog.Product.PRD_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PRDIM_PRD';

            PRINT N'            Expected Table                  : catalog.ProductImage';
            PRINT N'            Actual Table                    : '
                + COALESCE(@PRDIM_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : PRDIM_PRD_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRDIM_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.Product.PRD_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@PRDIM_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRDIM_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@PRDIM_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@PRDIM_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_FK_actual_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_FK_actual_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*======================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ======================================================================*/

        SELECT TOP (1)

            @PRDIM_FK_equivalent_name =
                fk.name,

            @PRDIM_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PRDIM_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PRDIM_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PRDIM_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.Product')

        AND fk.name <>
                @PRDIM_FK_expected_name

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
                    N'PRDIM_PRD_id'

            AND rc.name =
                    N'PRD_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @PRDIM_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PRDIM_PRD';

            PRINT N'            Actual Name                    : '
                + @PRDIM_FK_equivalent_name;

            PRINT N'            Column                         : PRDIM_PRD_id';

            PRINT N'            References                     : catalog.Product.PRD_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PRDIM_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PRDIM_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDIM_FK_equivalent_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            /*==================================================================
                VALIDATE EXPECTED NAME IS NOT USED BY ANOTHER FK
            ==================================================================*/

            IF OBJECT_ID(N'catalog.FK_PRDIM_PRD', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PRDIM_FK_conflict_parent =
                        QUOTENAME
                        (
                            OBJECT_SCHEMA_NAME
                            (
                                fk.parent_object_id
                            )
                        )
                        + N'.'
                        + QUOTENAME
                        (
                            OBJECT_NAME
                            (
                                fk.parent_object_id
                            )
                        )

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID
                        (
                            N'catalog.FK_PRDIM_PRD',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PRDIM_PRD';
                PRINT N'            Expected Table                  : catalog.ProductImage';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PRDIM_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50445,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE catalog.ProductImage
                WITH CHECK
                ADD CONSTRAINT FK_PRDIM_PRD
                FOREIGN KEY
                (
                    PRDIM_PRD_id
                )
                REFERENCES catalog.Product
                (
                    PRD_id
                );


            ALTER TABLE catalog.ProductImage
                CHECK CONSTRAINT FK_PRDIM_PRD;


            PRINT N'        [+] Foreign key constraint added    : FK_PRDIM_PRD';
            PRINT N'            Column                          : PRDIM_PRD_id';
            PRINT N'            References                      : catalog.Product.PRD_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';