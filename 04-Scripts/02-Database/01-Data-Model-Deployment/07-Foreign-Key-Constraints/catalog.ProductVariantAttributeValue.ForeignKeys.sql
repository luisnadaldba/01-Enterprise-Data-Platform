    PRINT N'';
    PRINT N'    ● catalog.ProductVariantAttributeValue';
    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_PRDAV_PRDVA
    ==============================================================================*/

    DECLARE @PRDAV_FK_PRDVA_expected_name                sysname;
    DECLARE @PRDAV_FK_PRDVA_actual_name                  sysname;

    DECLARE @PRDAV_FK_PRDVA_actual_parent_table          nvarchar(517);
    DECLARE @PRDAV_FK_PRDVA_actual_parent_columns        nvarchar(4000);

    DECLARE @PRDAV_FK_PRDVA_actual_referenced_table      nvarchar(517);
    DECLARE @PRDAV_FK_PRDVA_actual_referenced_columns    nvarchar(4000);

    DECLARE @PRDAV_FK_PRDVA_actual_delete_action         nvarchar(60);
    DECLARE @PRDAV_FK_PRDVA_actual_update_action         nvarchar(60);

    DECLARE @PRDAV_FK_PRDVA_actual_is_disabled           bit;
    DECLARE @PRDAV_FK_PRDVA_actual_is_not_trusted        bit;

    DECLARE @PRDAV_FK_PRDVA_equivalent_name              sysname;
    DECLARE @PRDAV_FK_PRDVA_equivalent_delete_action     nvarchar(60);
    DECLARE @PRDAV_FK_PRDVA_equivalent_update_action     nvarchar(60);
    DECLARE @PRDAV_FK_PRDVA_equivalent_is_disabled       bit;
    DECLARE @PRDAV_FK_PRDVA_equivalent_is_not_trusted    bit;

    DECLARE @PRDAV_FK_PRDVA_conflict_parent              nvarchar(517);

    SET @PRDAV_FK_PRDVA_expected_name = N'FK_PRDAV_PRDVA';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariantAttributeValue', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariantAttributeValue';

        ;THROW 50350,
            N'Foreign key FK_PRDAV_PRDVA cannot be deployed because catalog.ProductVariantAttributeValue does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariant';

        ;THROW 50351,
            N'Foreign key FK_PRDAV_PRDVA cannot be deployed because catalog.ProductVariant does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariantAttributeValue', N'PRDAV_PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PRDAV_PRDVA_id';

        ;THROW 50352,
            N'Foreign key FK_PRDAV_PRDVA cannot be deployed because PRDAV_PRDVA_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PRDVA_id';

        ;THROW 50353,
            N'Foreign key FK_PRDAV_PRDVA cannot be deployed because referenced column catalog.ProductVariant.PRDVA_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PRDAV_PRDVA_id -> int NOT NULL
            PRDVA_id -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')

        AND parent_column.name =
                N'PRDAV_PRDVA_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PRDAV_PRDVA_id -> PRDVA_id';

        ;THROW 50354,
            N'Foreign key FK_PRDAV_PRDVA cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PRDAV_PRDVA';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PRDAV_FK_PRDVA_actual_name =
            fk.name,

        @PRDAV_FK_PRDVA_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PRDAV_FK_PRDVA_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PRDAV_FK_PRDVA_actual_delete_action =
            fk.delete_referential_action_desc,

        @PRDAV_FK_PRDVA_actual_update_action =
            fk.update_referential_action_desc,

        @PRDAV_FK_PRDVA_actual_is_disabled =
            fk.is_disabled,

        @PRDAV_FK_PRDVA_actual_is_not_trusted =
            fk.is_not_trusted,

        @PRDAV_FK_PRDVA_actual_parent_columns =
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

        @PRDAV_FK_PRDVA_actual_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductVariantAttributeValue')

    AND fk.name =
            @PRDAV_FK_PRDVA_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PRDAV_FK_PRDVA_actual_name IS NOT NULL
    BEGIN

        IF @PRDAV_FK_PRDVA_actual_parent_table =
                N'[catalog].[ProductVariantAttributeValue]'

        AND @PRDAV_FK_PRDVA_actual_parent_columns =
                N'PRDAV_PRDVA_id'

        AND @PRDAV_FK_PRDVA_actual_referenced_table =
                N'[catalog].[ProductVariant]'

        AND @PRDAV_FK_PRDVA_actual_referenced_columns =
                N'PRDVA_id'

        AND @PRDAV_FK_PRDVA_actual_delete_action =
                N'NO_ACTION'

        AND @PRDAV_FK_PRDVA_actual_update_action =
                N'NO_ACTION'

        AND @PRDAV_FK_PRDVA_actual_is_disabled = 0

        AND @PRDAV_FK_PRDVA_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PRDAV_PRDVA';
            PRINT N'            Column                          : PRDAV_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PRDAV_PRDVA';

            PRINT N'            Expected Table                  : catalog.ProductVariantAttributeValue';

            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @PRDAV_FK_PRDVA_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : PRDAV_PRDVA_id';

            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRDAV_FK_PRDVA_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.ProductVariant.PRDVA_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @PRDAV_FK_PRDVA_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRDAV_FK_PRDVA_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';

            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @PRDAV_FK_PRDVA_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';

            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @PRDAV_FK_PRDVA_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';

            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDAV_FK_PRDVA_actual_is_disabled
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
                        @PRDAV_FK_PRDVA_actual_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*==============================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==============================================================================*/

        SELECT TOP (1)

            @PRDAV_FK_PRDVA_equivalent_name =
                fk.name,

            @PRDAV_FK_PRDVA_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PRDAV_FK_PRDVA_equivalent_update_action =
                fk.update_referential_action_desc,

            @PRDAV_FK_PRDVA_equivalent_is_disabled =
                fk.is_disabled,

            @PRDAV_FK_PRDVA_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND fk.name <>
                @PRDAV_FK_PRDVA_expected_name

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
                    N'PRDAV_PRDVA_id'

            AND rc.name =
                    N'PRDVA_id'
        )

        ORDER BY fk.name;


        IF @PRDAV_FK_PRDVA_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PRDAV_PRDVA';

            PRINT N'            Actual Name                    : '
                + @PRDAV_FK_PRDVA_equivalent_name;

            PRINT N'            Column                         : PRDAV_PRDVA_id';

            PRINT N'            References                     : catalog.ProductVariant.PRDVA_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PRDAV_FK_PRDVA_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PRDAV_FK_PRDVA_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDAV_FK_PRDVA_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDAV_FK_PRDVA_equivalent_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            /*==============================================================================
                VALIDATE EXPECTED NAME IS NOT USED BY ANOTHER FK
            ==============================================================================*/

            IF OBJECT_ID(N'catalog.FK_PRDAV_PRDVA', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PRDAV_FK_PRDVA_conflict_parent =
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
                            N'catalog.FK_PRDAV_PRDVA',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PRDAV_PRDVA';

                PRINT N'            Expected Table                  : catalog.ProductVariantAttributeValue';

                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PRDAV_FK_PRDVA_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50355,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE catalog.ProductVariantAttributeValue
                WITH CHECK
                ADD CONSTRAINT FK_PRDAV_PRDVA
                FOREIGN KEY
                (
                    PRDAV_PRDVA_id
                )
                REFERENCES catalog.ProductVariant
                (
                    PRDVA_id
                );


            ALTER TABLE catalog.ProductVariantAttributeValue
                CHECK CONSTRAINT FK_PRDAV_PRDVA;


            PRINT N'        [+] Foreign key constraint added    : FK_PRDAV_PRDVA';
            PRINT N'            Column                          : PRDAV_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_PRDAV_PATVL
    ==============================================================================*/

    DECLARE @PRDAV_FK_PATVL_expected_name                sysname;
    DECLARE @PRDAV_FK_PATVL_actual_name                  sysname;

    DECLARE @PRDAV_FK_PATVL_actual_parent_table          nvarchar(517);
    DECLARE @PRDAV_FK_PATVL_actual_parent_columns        nvarchar(4000);

    DECLARE @PRDAV_FK_PATVL_actual_referenced_table      nvarchar(517);
    DECLARE @PRDAV_FK_PATVL_actual_referenced_columns    nvarchar(4000);

    DECLARE @PRDAV_FK_PATVL_actual_delete_action         nvarchar(60);
    DECLARE @PRDAV_FK_PATVL_actual_update_action         nvarchar(60);

    DECLARE @PRDAV_FK_PATVL_actual_is_disabled           bit;
    DECLARE @PRDAV_FK_PATVL_actual_is_not_trusted        bit;

    DECLARE @PRDAV_FK_PATVL_equivalent_name              sysname;
    DECLARE @PRDAV_FK_PATVL_equivalent_delete_action     nvarchar(60);
    DECLARE @PRDAV_FK_PATVL_equivalent_update_action     nvarchar(60);
    DECLARE @PRDAV_FK_PATVL_equivalent_is_disabled       bit;
    DECLARE @PRDAV_FK_PATVL_equivalent_is_not_trusted    bit;

    DECLARE @PRDAV_FK_PATVL_conflict_parent              nvarchar(517);

    SET @PRDAV_FK_PATVL_expected_name = N'FK_PRDAV_PATVL';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'catalog.ProductVariantAttributeValue', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariantAttributeValue';

        ;THROW 50360,
            N'Foreign key FK_PRDAV_PATVL cannot be deployed because catalog.ProductVariantAttributeValue does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.ProductAttributeValue', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductAttributeValue';

        ;THROW 50361,
            N'Foreign key FK_PRDAV_PATVL cannot be deployed because catalog.ProductAttributeValue does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariantAttributeValue', N'PRDAV_PATVL_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PRDAV_PATVL_id';

        ;THROW 50362,
            N'Foreign key FK_PRDAV_PATVL cannot be deployed because PRDAV_PATVL_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductAttributeValue', N'PATVL_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PATVL_id';

        ;THROW 50363,
            N'Foreign key FK_PRDAV_PATVL cannot be deployed because referenced column catalog.ProductAttributeValue.PATVL_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PRDAV_PATVL_id -> int NOT NULL
            PATVL_id -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.ProductAttributeValue')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')

        AND parent_column.name =
                N'PRDAV_PATVL_id'

        AND referenced_column.name =
                N'PATVL_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PRDAV_PATVL_id -> PATVL_id';

        ;THROW 50364,
            N'Foreign key FK_PRDAV_PATVL cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PRDAV_PATVL';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @PRDAV_FK_PATVL_actual_name =
            fk.name,

        @PRDAV_FK_PATVL_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PRDAV_FK_PATVL_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PRDAV_FK_PATVL_actual_delete_action =
            fk.delete_referential_action_desc,

        @PRDAV_FK_PATVL_actual_update_action =
            fk.update_referential_action_desc,

        @PRDAV_FK_PATVL_actual_is_disabled =
            fk.is_disabled,

        @PRDAV_FK_PATVL_actual_is_not_trusted =
            fk.is_not_trusted,

        @PRDAV_FK_PATVL_actual_parent_columns =
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

        @PRDAV_FK_PATVL_actual_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductVariantAttributeValue')

    AND fk.name =
            @PRDAV_FK_PATVL_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @PRDAV_FK_PATVL_actual_name IS NOT NULL
    BEGIN

        IF @PRDAV_FK_PATVL_actual_parent_table =
                N'[catalog].[ProductVariantAttributeValue]'

        AND @PRDAV_FK_PATVL_actual_parent_columns =
                N'PRDAV_PATVL_id'

        AND @PRDAV_FK_PATVL_actual_referenced_table =
                N'[catalog].[ProductAttributeValue]'

        AND @PRDAV_FK_PATVL_actual_referenced_columns =
                N'PATVL_id'

        AND @PRDAV_FK_PATVL_actual_delete_action =
                N'NO_ACTION'

        AND @PRDAV_FK_PATVL_actual_update_action =
                N'NO_ACTION'

        AND @PRDAV_FK_PATVL_actual_is_disabled = 0

        AND @PRDAV_FK_PATVL_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PRDAV_PATVL';
            PRINT N'            Column                          : PRDAV_PATVL_id';
            PRINT N'            References                      : catalog.ProductAttributeValue.PATVL_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PRDAV_PATVL';

            PRINT N'            Expected Table                  : catalog.ProductVariantAttributeValue';

            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @PRDAV_FK_PATVL_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : PRDAV_PATVL_id';

            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRDAV_FK_PATVL_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.ProductAttributeValue.PATVL_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @PRDAV_FK_PATVL_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRDAV_FK_PATVL_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';

            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @PRDAV_FK_PATVL_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';

            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @PRDAV_FK_PATVL_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';

            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDAV_FK_PATVL_actual_is_disabled
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
                        @PRDAV_FK_PATVL_actual_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*==============================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==============================================================================*/

        SELECT TOP (1)

            @PRDAV_FK_PATVL_equivalent_name =
                fk.name,

            @PRDAV_FK_PATVL_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PRDAV_FK_PATVL_equivalent_update_action =
                fk.update_referential_action_desc,

            @PRDAV_FK_PATVL_equivalent_is_disabled =
                fk.is_disabled,

            @PRDAV_FK_PATVL_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.ProductVariantAttributeValue')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductAttributeValue')

        AND fk.name <>
                @PRDAV_FK_PATVL_expected_name

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
                    N'PRDAV_PATVL_id'

            AND rc.name =
                    N'PATVL_id'
        )

        ORDER BY fk.name;


        IF @PRDAV_FK_PATVL_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PRDAV_PATVL';

            PRINT N'            Actual Name                    : '
                + @PRDAV_FK_PATVL_equivalent_name;

            PRINT N'            Column                         : PRDAV_PATVL_id';

            PRINT N'            References                     : catalog.ProductAttributeValue.PATVL_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PRDAV_FK_PATVL_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PRDAV_FK_PATVL_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDAV_FK_PATVL_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRDAV_FK_PATVL_equivalent_is_not_trusted
                    ),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            /*==============================================================================
                VALIDATE EXPECTED NAME IS NOT USED BY ANOTHER FK
            ==============================================================================*/

            IF OBJECT_ID(N'catalog.FK_PRDAV_PATVL', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PRDAV_FK_PATVL_conflict_parent =
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
                            N'catalog.FK_PRDAV_PATVL',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PRDAV_PATVL';

                PRINT N'            Expected Table                  : catalog.ProductVariantAttributeValue';

                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PRDAV_FK_PATVL_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50365,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE catalog.ProductVariantAttributeValue
                WITH CHECK
                ADD CONSTRAINT FK_PRDAV_PATVL
                FOREIGN KEY
                (
                    PRDAV_PATVL_id
                )
                REFERENCES catalog.ProductAttributeValue
                (
                    PATVL_id
                );


            ALTER TABLE catalog.ProductVariantAttributeValue
                CHECK CONSTRAINT FK_PRDAV_PATVL;


            PRINT N'        [+] Foreign key constraint added    : FK_PRDAV_PATVL';
            PRINT N'            Column                          : PRDAV_PATVL_id';
            PRINT N'            References                      : catalog.ProductAttributeValue.PATVL_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';