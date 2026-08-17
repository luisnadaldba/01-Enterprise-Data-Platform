    PRINT N'    inventory.Inventory';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FOREIGN KEY: FK_INV_PRDVA
    ==============================================================================*/

    DECLARE @INV_PRDVA_FK_expected_name                sysname;
    DECLARE @INV_PRDVA_FK_actual_name                  sysname;

    DECLARE @INV_PRDVA_FK_actual_parent_table          nvarchar(517);
    DECLARE @INV_PRDVA_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @INV_PRDVA_FK_actual_referenced_table      nvarchar(517);
    DECLARE @INV_PRDVA_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @INV_PRDVA_FK_actual_delete_action         nvarchar(60);
    DECLARE @INV_PRDVA_FK_actual_update_action         nvarchar(60);

    DECLARE @INV_PRDVA_FK_actual_is_disabled           bit;
    DECLARE @INV_PRDVA_FK_actual_is_not_trusted        bit;

    DECLARE @INV_PRDVA_FK_equivalent_name              sysname;
    DECLARE @INV_PRDVA_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @INV_PRDVA_FK_equivalent_update_action     nvarchar(60);
    DECLARE @INV_PRDVA_FK_equivalent_is_disabled       bit;
    DECLARE @INV_PRDVA_FK_equivalent_is_not_trusted    bit;

    DECLARE @INV_PRDVA_FK_conflict_parent              nvarchar(517);


    SET @INV_PRDVA_FK_expected_name = N'FK_INV_PRDVA';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.Inventory', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.Inventory';

        ;THROW 50570,
            N'Foreign key FK_INV_PRDVA cannot be deployed because inventory.Inventory does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariant';

        ;THROW 50571,
            N'Foreign key FK_INV_PRDVA cannot be deployed because catalog.ProductVariant does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.Inventory', N'INV_PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INV_PRDVA_id';

        ;THROW 50572,
            N'Foreign key FK_INV_PRDVA cannot be deployed because INV_PRDVA_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PRDVA_id';

        ;THROW 50573,
            N'Foreign key FK_INV_PRDVA cannot be deployed because referenced column catalog.ProductVariant.PRDVA_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            INV_PRDVA_id -> int NOT NULL
            PRDVA_id     -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.ProductVariant')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND parent_column.name =
                N'INV_PRDVA_id'

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

        PRINT N'        [X] Foreign key column mismatch    : INV_PRDVA_id -> PRDVA_id';

        ;THROW 50574,
            N'Foreign key FK_INV_PRDVA cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INV_PRDVA';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @INV_PRDVA_FK_actual_name =
            fk.name,

        @INV_PRDVA_FK_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @INV_PRDVA_FK_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @INV_PRDVA_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @INV_PRDVA_FK_actual_update_action =
            fk.update_referential_action_desc,

        @INV_PRDVA_FK_actual_is_disabled =
            fk.is_disabled,

        @INV_PRDVA_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @INV_PRDVA_FK_actual_parent_columns =
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

        @INV_PRDVA_FK_actual_referenced_columns =
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
            OBJECT_ID(N'inventory.Inventory')

    AND fk.name =
            @INV_PRDVA_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @INV_PRDVA_FK_actual_name IS NOT NULL
    BEGIN

        IF @INV_PRDVA_FK_actual_parent_table =
                N'[inventory].[Inventory]'

        AND @INV_PRDVA_FK_actual_parent_columns =
                N'INV_PRDVA_id'

        AND @INV_PRDVA_FK_actual_referenced_table =
                N'[catalog].[ProductVariant]'

        AND @INV_PRDVA_FK_actual_referenced_columns =
                N'PRDVA_id'

        AND @INV_PRDVA_FK_actual_delete_action =
                N'NO_ACTION'

        AND @INV_PRDVA_FK_actual_update_action =
                N'NO_ACTION'

        AND @INV_PRDVA_FK_actual_is_disabled = 0

        AND @INV_PRDVA_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_INV_PRDVA';
            PRINT N'            Column                          : INV_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_INV_PRDVA';

            PRINT N'            Expected Table                  : inventory.Inventory';
            PRINT N'            Actual Table                    : '
                + COALESCE(@INV_PRDVA_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : INV_PRDVA_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INV_PRDVA_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.ProductVariant.PRDVA_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@INV_PRDVA_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INV_PRDVA_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@INV_PRDVA_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@INV_PRDVA_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_PRDVA_FK_actual_is_disabled),
                    N'<NULL>'
                );

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_PRDVA_FK_actual_is_not_trusted),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*==========================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==========================================================================*/

        SELECT TOP (1)

            @INV_PRDVA_FK_equivalent_name =
                fk.name,

            @INV_PRDVA_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @INV_PRDVA_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @INV_PRDVA_FK_equivalent_is_disabled =
                fk.is_disabled,

            @INV_PRDVA_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.Inventory')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND fk.name <>
                @INV_PRDVA_FK_expected_name

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
                    N'INV_PRDVA_id'

            AND rc.name =
                    N'PRDVA_id'
        )

        ORDER BY fk.name;


        IF @INV_PRDVA_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_INV_PRDVA';

            PRINT N'            Actual Name                    : '
                + @INV_PRDVA_FK_equivalent_name;

            PRINT N'            Column                         : INV_PRDVA_id';

            PRINT N'            References                     : catalog.ProductVariant.PRDVA_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE(@INV_PRDVA_FK_equivalent_delete_action, N'<NULL>');

            PRINT N'            ON UPDATE                      : '
                + COALESCE(@INV_PRDVA_FK_equivalent_update_action, N'<NULL>');

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_PRDVA_FK_equivalent_is_disabled),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @INV_PRDVA_FK_equivalent_is_not_trusted),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            IF OBJECT_ID(N'inventory.FK_INV_PRDVA', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @INV_PRDVA_FK_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'inventory.FK_INV_PRDVA', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_INV_PRDVA';
                PRINT N'            Expected Table                  : inventory.Inventory';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@INV_PRDVA_FK_conflict_parent, N'<UNKNOWN>');

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50575,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            ALTER TABLE inventory.Inventory
                WITH CHECK
                ADD CONSTRAINT FK_INV_PRDVA
                FOREIGN KEY
                (
                    INV_PRDVA_id
                )
                REFERENCES catalog.ProductVariant
                (
                    PRDVA_id
                );


            ALTER TABLE inventory.Inventory
                CHECK CONSTRAINT FK_INV_PRDVA;


            PRINT N'        [+] Foreign key constraint added    : FK_INV_PRDVA';
            PRINT N'            Column                          : INV_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;

    PRINT N'';