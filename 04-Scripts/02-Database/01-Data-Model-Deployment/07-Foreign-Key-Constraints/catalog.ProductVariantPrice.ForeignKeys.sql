    PRINT N'';
    PRINT N'    ● catalog.ProductVariantPrice';
    PRINT N'';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @PRDVP_FK_expected_name                sysname;
    DECLARE @PRDVP_FK_actual_name                  sysname;

    DECLARE @PRDVP_FK_actual_parent_table          nvarchar(517);
    DECLARE @PRDVP_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PRDVP_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PRDVP_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PRDVP_FK_actual_delete_action         nvarchar(60);
    DECLARE @PRDVP_FK_actual_update_action         nvarchar(60);

    DECLARE @PRDVP_FK_actual_is_disabled           bit;
    DECLARE @PRDVP_FK_actual_is_not_trusted        bit;

    DECLARE @PRDVP_FK_equivalent_name              sysname;
    DECLARE @PRDVP_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PRDVP_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PRDVP_FK_equivalent_is_disabled       bit;
    DECLARE @PRDVP_FK_equivalent_is_not_trusted    bit;

    DECLARE @PRDVP_FK_conflict_parent              nvarchar(517);


    SET @PRDVP_FK_expected_name = N'FK_PRDVP_PRDVA';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariantPrice', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariantPrice';

        ;THROW 50500,
            N'Foreign key FK_PRDVP_PRDVA cannot be deployed because catalog.ProductVariantPrice does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariant';

        ;THROW 50501,
            N'Foreign key FK_PRDVP_PRDVA cannot be deployed because catalog.ProductVariant does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariantPrice', N'PRDVP_PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PRDVP_PRDVA_id';

        ;THROW 50502,
            N'Foreign key FK_PRDVP_PRDVA cannot be deployed because PRDVP_PRDVA_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PRDVA_id';

        ;THROW 50503,
            N'Foreign key FK_PRDVP_PRDVA cannot be deployed because referenced column catalog.ProductVariant.PRDVA_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PRDVP_PRDVA_id -> int NOT NULL
            PRDVA_id       -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND parent_column.name =
                N'PRDVP_PRDVA_id'

        AND referenced_column.name =
                N'PRDVA_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PRDVP_PRDVA_id -> PRDVA_id';

        ;THROW 50504,
            N'Foreign key FK_PRDVP_PRDVA cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PRDVP_PRDVA';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @PRDVP_FK_actual_name =
            fk.name,

        @PRDVP_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PRDVP_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PRDVP_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PRDVP_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PRDVP_FK_actual_is_disabled =
            fk.is_disabled,

        @PRDVP_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PRDVP_FK_actual_parent_columns =
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

        @PRDVP_FK_actual_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductVariantPrice')

    AND fk.name =
            @PRDVP_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @PRDVP_FK_actual_name IS NOT NULL
    BEGIN

        IF @PRDVP_FK_actual_parent_table =
                N'[catalog].[ProductVariantPrice]'

        AND @PRDVP_FK_actual_parent_columns =
                N'PRDVP_PRDVA_id'

        AND @PRDVP_FK_actual_referenced_table =
                N'[catalog].[ProductVariant]'

        AND @PRDVP_FK_actual_referenced_columns =
                N'PRDVA_id'

        AND @PRDVP_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PRDVP_FK_actual_update_action =
                N'NO_ACTION'

        AND @PRDVP_FK_actual_is_disabled = 0

        AND @PRDVP_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PRDVP_PRDVA';
            PRINT N'            Column                          : PRDVP_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PRDVP_PRDVA';

            PRINT N'            Expected Table                  : catalog.ProductVariantPrice';
            PRINT N'            Actual Table                    : '
                + COALESCE(@PRDVP_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : PRDVP_PRDVA_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRDVP_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.ProductVariant.PRDVA_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@PRDVP_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRDVP_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@PRDVP_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@PRDVP_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_FK_actual_is_disabled
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
                        @PRDVP_FK_actual_is_not_trusted
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

            @PRDVP_FK_equivalent_name =
                fk.name,

            @PRDVP_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PRDVP_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PRDVP_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PRDVP_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND fk.name <>
                @PRDVP_FK_expected_name

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
                    N'PRDVP_PRDVA_id'

            AND rc.name =
                    N'PRDVA_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @PRDVP_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PRDVP_PRDVA';

            PRINT N'            Actual Name                    : '
                + @PRDVP_FK_equivalent_name;

            PRINT N'            Column                         : PRDVP_PRDVA_id';

            PRINT N'            References                     : catalog.ProductVariant.PRDVA_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PRDVP_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PRDVP_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDVP_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'catalog.FK_PRDVP_PRDVA', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PRDVP_FK_conflict_parent =
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
                            N'catalog.FK_PRDVP_PRDVA',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PRDVP_PRDVA';
                PRINT N'            Expected Table                  : catalog.ProductVariantPrice';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PRDVP_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50505,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE catalog.ProductVariantPrice
                WITH CHECK
                ADD CONSTRAINT FK_PRDVP_PRDVA
                FOREIGN KEY
                (
                    PRDVP_PRDVA_id
                )
                REFERENCES catalog.ProductVariant
                (
                    PRDVA_id
                );


            ALTER TABLE catalog.ProductVariantPrice
                CHECK CONSTRAINT FK_PRDVP_PRDVA;


            PRINT N'        [+] Foreign key constraint added    : FK_PRDVP_PRDVA';
            PRINT N'            Column                          : PRDVP_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';