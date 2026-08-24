    PRINT N'';
    PRINT N'    ● inventory.InventoryMovement';
    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_INVMV_PRDVA
    ==============================================================================*/

    DECLARE @INVMV_PRDVA_FK_expected_name                sysname;
    DECLARE @INVMV_PRDVA_FK_actual_name                  sysname;

    DECLARE @INVMV_PRDVA_FK_actual_parent_table          nvarchar(517);
    DECLARE @INVMV_PRDVA_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @INVMV_PRDVA_FK_actual_referenced_table      nvarchar(517);
    DECLARE @INVMV_PRDVA_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @INVMV_PRDVA_FK_actual_delete_action         nvarchar(60);
    DECLARE @INVMV_PRDVA_FK_actual_update_action         nvarchar(60);

    DECLARE @INVMV_PRDVA_FK_actual_is_disabled           bit;
    DECLARE @INVMV_PRDVA_FK_actual_is_not_trusted        bit;

    DECLARE @INVMV_PRDVA_FK_equivalent_name              sysname;
    DECLARE @INVMV_PRDVA_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @INVMV_PRDVA_FK_equivalent_update_action     nvarchar(60);
    DECLARE @INVMV_PRDVA_FK_equivalent_is_disabled       bit;
    DECLARE @INVMV_PRDVA_FK_equivalent_is_not_trusted    bit;

    DECLARE @INVMV_PRDVA_FK_conflict_parent              nvarchar(517);


    SET @INVMV_PRDVA_FK_expected_name = N'FK_INVMV_PRDVA';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovement', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryMovement';

        ;THROW 50930,
            N'Foreign key FK_INVMV_PRDVA cannot be deployed because inventory.InventoryMovement does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.ProductVariant', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductVariant';

        ;THROW 50931,
            N'Foreign key FK_INVMV_PRDVA cannot be deployed because catalog.ProductVariant does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVMV_PRDVA_id';

        ;THROW 50932,
            N'Foreign key FK_INVMV_PRDVA cannot be deployed because INVMV_PRDVA_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductVariant', N'PRDVA_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PRDVA_id';

        ;THROW 50933,
            N'Foreign key FK_INVMV_PRDVA cannot be deployed because referenced column catalog.ProductVariant.PRDVA_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            INVMV_PRDVA_id -> int NOT NULL
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
                OBJECT_ID(N'inventory.InventoryMovement')

        AND parent_column.name =
                N'INVMV_PRDVA_id'

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

        PRINT N'        [X] Foreign key column mismatch    : INVMV_PRDVA_id -> PRDVA_id';

        ;THROW 50934,
            N'Foreign key FK_INVMV_PRDVA cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVMV_PRDVA';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @INVMV_PRDVA_FK_actual_name =
            fk.name,

        @INVMV_PRDVA_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @INVMV_PRDVA_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @INVMV_PRDVA_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @INVMV_PRDVA_FK_actual_update_action =
            fk.update_referential_action_desc,

        @INVMV_PRDVA_FK_actual_is_disabled =
            fk.is_disabled,

        @INVMV_PRDVA_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @INVMV_PRDVA_FK_actual_parent_columns =
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

        @INVMV_PRDVA_FK_actual_referenced_columns =
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
            OBJECT_ID(N'inventory.InventoryMovement')

    AND fk.name =
            @INVMV_PRDVA_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @INVMV_PRDVA_FK_actual_name IS NOT NULL
    BEGIN

        IF @INVMV_PRDVA_FK_actual_parent_table =
                N'[inventory].[InventoryMovement]'

        AND @INVMV_PRDVA_FK_actual_parent_columns =
                N'INVMV_PRDVA_id'

        AND @INVMV_PRDVA_FK_actual_referenced_table =
                N'[catalog].[ProductVariant]'

        AND @INVMV_PRDVA_FK_actual_referenced_columns =
                N'PRDVA_id'

        AND @INVMV_PRDVA_FK_actual_delete_action =
                N'NO_ACTION'

        AND @INVMV_PRDVA_FK_actual_update_action =
                N'NO_ACTION'

        AND @INVMV_PRDVA_FK_actual_is_disabled = 0

        AND @INVMV_PRDVA_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_INVMV_PRDVA';
            PRINT N'            Column                          : INVMV_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_INVMV_PRDVA';

            PRINT N'            Expected Table                  : inventory.InventoryMovement';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @INVMV_PRDVA_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : INVMV_PRDVA_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVMV_PRDVA_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.ProductVariant.PRDVA_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @INVMV_PRDVA_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVMV_PRDVA_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @INVMV_PRDVA_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @INVMV_PRDVA_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_PRDVA_FK_actual_is_disabled
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
                        @INVMV_PRDVA_FK_actual_is_not_trusted
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

            @INVMV_PRDVA_FK_equivalent_name =
                fk.name,

            @INVMV_PRDVA_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @INVMV_PRDVA_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @INVMV_PRDVA_FK_equivalent_is_disabled =
                fk.is_disabled,

            @INVMV_PRDVA_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductVariant')

        AND fk.name <>
                @INVMV_PRDVA_FK_expected_name

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
                    N'INVMV_PRDVA_id'

            AND rc.name =
                    N'PRDVA_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @INVMV_PRDVA_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_INVMV_PRDVA';

            PRINT N'            Actual Name                    : '
                + @INVMV_PRDVA_FK_equivalent_name;

            PRINT N'            Column                         : INVMV_PRDVA_id';

            PRINT N'            References                     : catalog.ProductVariant.PRDVA_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @INVMV_PRDVA_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @INVMV_PRDVA_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_PRDVA_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_PRDVA_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'inventory.FK_INVMV_PRDVA', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @INVMV_PRDVA_FK_conflict_parent =
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
                            N'inventory.FK_INVMV_PRDVA',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_INVMV_PRDVA';
                PRINT N'            Expected Table                  : inventory.InventoryMovement';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @INVMV_PRDVA_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50935,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE inventory.InventoryMovement
                WITH CHECK
                ADD CONSTRAINT FK_INVMV_PRDVA
                FOREIGN KEY
                (
                    INVMV_PRDVA_id
                )
                REFERENCES catalog.ProductVariant
                (
                    PRDVA_id
                );


            ALTER TABLE inventory.InventoryMovement
                CHECK CONSTRAINT FK_INVMV_PRDVA;


            PRINT N'        [+] Foreign key constraint added    : FK_INVMV_PRDVA';
            PRINT N'            Column                          : INVMV_PRDVA_id';
            PRINT N'            References                      : catalog.ProductVariant.PRDVA_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_INVMV_INVMR
    ==============================================================================*/

    DECLARE @INVMV_INVMR_FK_expected_name                sysname;
    DECLARE @INVMV_INVMR_FK_actual_name                  sysname;

    DECLARE @INVMV_INVMR_FK_actual_parent_table          nvarchar(517);
    DECLARE @INVMV_INVMR_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @INVMV_INVMR_FK_actual_referenced_table      nvarchar(517);
    DECLARE @INVMV_INVMR_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @INVMV_INVMR_FK_actual_delete_action         nvarchar(60);
    DECLARE @INVMV_INVMR_FK_actual_update_action         nvarchar(60);

    DECLARE @INVMV_INVMR_FK_actual_is_disabled           bit;
    DECLARE @INVMV_INVMR_FK_actual_is_not_trusted        bit;

    DECLARE @INVMV_INVMR_FK_equivalent_name              sysname;
    DECLARE @INVMV_INVMR_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @INVMV_INVMR_FK_equivalent_update_action     nvarchar(60);
    DECLARE @INVMV_INVMR_FK_equivalent_is_disabled       bit;
    DECLARE @INVMV_INVMR_FK_equivalent_is_not_trusted    bit;

    DECLARE @INVMV_INVMR_FK_conflict_parent              nvarchar(517);


    SET @INVMV_INVMR_FK_expected_name = N'FK_INVMV_INVMR';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovement', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryMovement';

        ;THROW 50940,
            N'Foreign key FK_INVMV_INVMR cannot be deployed because inventory.InventoryMovement does not exist.',
            1;

    END;


    IF OBJECT_ID(N'inventory.InventoryMovementReason', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryMovementReason';

        ;THROW 50941,
            N'Foreign key FK_INVMV_INVMR cannot be deployed because inventory.InventoryMovementReason does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_INVMR_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVMV_INVMR_id';

        ;THROW 50942,
            N'Foreign key FK_INVMV_INVMR cannot be deployed because INVMV_INVMR_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryMovementReason', N'INVMR_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : INVMR_id';

        ;THROW 50943,
            N'Foreign key FK_INVMV_INVMR cannot be deployed because referenced column inventory.InventoryMovementReason.INVMR_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            INVMV_INVMR_id -> smallint NOT NULL
            INVMR_id       -> smallint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'inventory.InventoryMovementReason')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND parent_column.name =
                N'INVMV_INVMR_id'

        AND referenced_column.name =
                N'INVMR_id'

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

        PRINT N'        [X] Foreign key column mismatch    : INVMV_INVMR_id -> INVMR_id';

        ;THROW 50944,
            N'Foreign key FK_INVMV_INVMR cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVMV_INVMR';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @INVMV_INVMR_FK_actual_name =
            fk.name,

        @INVMV_INVMR_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @INVMV_INVMR_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @INVMV_INVMR_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @INVMV_INVMR_FK_actual_update_action =
            fk.update_referential_action_desc,

        @INVMV_INVMR_FK_actual_is_disabled =
            fk.is_disabled,

        @INVMV_INVMR_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @INVMV_INVMR_FK_actual_parent_columns =
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

        @INVMV_INVMR_FK_actual_referenced_columns =
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
            OBJECT_ID(N'inventory.InventoryMovement')

    AND fk.name =
            @INVMV_INVMR_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @INVMV_INVMR_FK_actual_name IS NOT NULL
    BEGIN

        IF @INVMV_INVMR_FK_actual_parent_table =
                N'[inventory].[InventoryMovement]'

        AND @INVMV_INVMR_FK_actual_parent_columns =
                N'INVMV_INVMR_id'

        AND @INVMV_INVMR_FK_actual_referenced_table =
                N'[inventory].[InventoryMovementReason]'

        AND @INVMV_INVMR_FK_actual_referenced_columns =
                N'INVMR_id'

        AND @INVMV_INVMR_FK_actual_delete_action =
                N'NO_ACTION'

        AND @INVMV_INVMR_FK_actual_update_action =
                N'NO_ACTION'

        AND @INVMV_INVMR_FK_actual_is_disabled = 0

        AND @INVMV_INVMR_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_INVMV_INVMR';
            PRINT N'            Column                          : INVMV_INVMR_id';
            PRINT N'            References                      : inventory.InventoryMovementReason.INVMR_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_INVMV_INVMR';

            PRINT N'            Expected Table                  : inventory.InventoryMovement';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @INVMV_INVMR_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : INVMV_INVMR_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVMV_INVMR_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : inventory.InventoryMovementReason.INVMR_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @INVMV_INVMR_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVMV_INVMR_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @INVMV_INVMR_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @INVMV_INVMR_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_INVMR_FK_actual_is_disabled
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
                        @INVMV_INVMR_FK_actual_is_not_trusted
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

            @INVMV_INVMR_FK_equivalent_name =
                fk.name,

            @INVMV_INVMR_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @INVMV_INVMR_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @INVMV_INVMR_FK_equivalent_is_disabled =
                fk.is_disabled,

            @INVMV_INVMR_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND fk.referenced_object_id =
                OBJECT_ID(N'inventory.InventoryMovementReason')

        AND fk.name <>
                @INVMV_INVMR_FK_expected_name

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
                    N'INVMV_INVMR_id'

            AND rc.name =
                    N'INVMR_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @INVMV_INVMR_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_INVMV_INVMR';

            PRINT N'            Actual Name                    : '
                + @INVMV_INVMR_FK_equivalent_name;

            PRINT N'            Column                         : INVMV_INVMR_id';

            PRINT N'            References                     : inventory.InventoryMovementReason.INVMR_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @INVMV_INVMR_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @INVMV_INVMR_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_INVMR_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_INVMR_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'inventory.FK_INVMV_INVMR', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @INVMV_INVMR_FK_conflict_parent =
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
                            N'inventory.FK_INVMV_INVMR',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_INVMV_INVMR';
                PRINT N'            Expected Table                  : inventory.InventoryMovement';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @INVMV_INVMR_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50945,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE inventory.InventoryMovement
                WITH CHECK
                ADD CONSTRAINT FK_INVMV_INVMR
                FOREIGN KEY
                (
                    INVMV_INVMR_id
                )
                REFERENCES inventory.InventoryMovementReason
                (
                    INVMR_id
                );


            ALTER TABLE inventory.InventoryMovement
                CHECK CONSTRAINT FK_INVMV_INVMR;


            PRINT N'        [+] Foreign key constraint added    : FK_INVMV_INVMR';
            PRINT N'            Column                          : INVMV_INVMR_id';
            PRINT N'            References                      : inventory.InventoryMovementReason.INVMR_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_INVMV_TRNIT
    ==============================================================================*/

    DECLARE @INVMV_TRNIT_FK_expected_name                sysname;
    DECLARE @INVMV_TRNIT_FK_actual_name                  sysname;

    DECLARE @INVMV_TRNIT_FK_actual_parent_table          nvarchar(517);
    DECLARE @INVMV_TRNIT_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @INVMV_TRNIT_FK_actual_referenced_table      nvarchar(517);
    DECLARE @INVMV_TRNIT_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @INVMV_TRNIT_FK_actual_delete_action         nvarchar(60);
    DECLARE @INVMV_TRNIT_FK_actual_update_action         nvarchar(60);

    DECLARE @INVMV_TRNIT_FK_actual_is_disabled           bit;
    DECLARE @INVMV_TRNIT_FK_actual_is_not_trusted        bit;

    DECLARE @INVMV_TRNIT_FK_equivalent_name              sysname;
    DECLARE @INVMV_TRNIT_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @INVMV_TRNIT_FK_equivalent_update_action     nvarchar(60);
    DECLARE @INVMV_TRNIT_FK_equivalent_is_disabled       bit;
    DECLARE @INVMV_TRNIT_FK_equivalent_is_not_trusted    bit;

    DECLARE @INVMV_TRNIT_FK_conflict_parent              nvarchar(517);


    SET @INVMV_TRNIT_FK_expected_name = N'FK_INVMV_TRNIT';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovement', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryMovement';

        ;THROW 50950,
            N'Foreign key FK_INVMV_TRNIT cannot be deployed because inventory.InventoryMovement does not exist.',
            1;

    END;


    IF OBJECT_ID(N'sales.TransactionItem', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.TransactionItem';

        ;THROW 50951,
            N'Foreign key FK_INVMV_TRNIT cannot be deployed because sales.TransactionItem does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_TRNIT_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVMV_TRNIT_id';

        ;THROW 50952,
            N'Foreign key FK_INVMV_TRNIT cannot be deployed because INVMV_TRNIT_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_TRNIT_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVMV_TRNIT_transaction_at';

        ;THROW 50953,
            N'Foreign key FK_INVMV_TRNIT cannot be deployed because INVMV_TRNIT_transaction_at does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRNIT_id';

        ;THROW 50954,
            N'Foreign key FK_INVMV_TRNIT cannot be deployed because referenced column sales.TransactionItem.TRNIT_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionItem', N'TRNIT_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRNIT_transaction_at';

        ;THROW 50955,
            N'Foreign key FK_INVMV_TRNIT cannot be deployed because referenced column sales.TransactionItem.TRNIT_transaction_at does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            INVMV_TRNIT_id             -> bigint NULL
            TRNIT_id                   -> bigint NOT NULL
            INVMV_TRNIT_transaction_at -> datetime2 NULL
            TRNIT_transaction_at       -> datetime2 NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND parent_column.name =
                N'INVMV_TRNIT_id'

        AND referenced_column.name =
                N'TRNIT_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'bigint'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'bigint'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : INVMV_TRNIT_id -> TRNIT_id';

        ;THROW 50956,
            N'Foreign key FK_INVMV_TRNIT cannot be deployed because participating columns are incompatible.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.TransactionItem')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND parent_column.name =
                N'INVMV_TRNIT_transaction_at'

        AND referenced_column.name =
                N'TRNIT_transaction_at'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'datetime2'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'datetime2'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : INVMV_TRNIT_transaction_at -> TRNIT_transaction_at';

        ;THROW 50957,
            N'Foreign key FK_INVMV_TRNIT cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVMV_TRNIT';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @INVMV_TRNIT_FK_actual_name =
            fk.name,

        @INVMV_TRNIT_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @INVMV_TRNIT_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @INVMV_TRNIT_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @INVMV_TRNIT_FK_actual_update_action =
            fk.update_referential_action_desc,

        @INVMV_TRNIT_FK_actual_is_disabled =
            fk.is_disabled,

        @INVMV_TRNIT_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @INVMV_TRNIT_FK_actual_parent_columns =
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

        @INVMV_TRNIT_FK_actual_referenced_columns =
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
            OBJECT_ID(N'inventory.InventoryMovement')

    AND fk.name =
            @INVMV_TRNIT_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @INVMV_TRNIT_FK_actual_name IS NOT NULL
    BEGIN

        IF @INVMV_TRNIT_FK_actual_parent_table =
                N'[inventory].[InventoryMovement]'

        AND @INVMV_TRNIT_FK_actual_parent_columns =
                N'INVMV_TRNIT_id|INVMV_TRNIT_transaction_at'

        AND @INVMV_TRNIT_FK_actual_referenced_table =
                N'[sales].[TransactionItem]'

        AND @INVMV_TRNIT_FK_actual_referenced_columns =
                N'TRNIT_id|TRNIT_transaction_at'

        AND @INVMV_TRNIT_FK_actual_delete_action =
                N'NO_ACTION'

        AND @INVMV_TRNIT_FK_actual_update_action =
                N'NO_ACTION'

        AND @INVMV_TRNIT_FK_actual_is_disabled = 0

        AND @INVMV_TRNIT_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_INVMV_TRNIT';
            PRINT N'            Columns                         : INVMV_TRNIT_id, INVMV_TRNIT_transaction_at';
            PRINT N'            References                      : sales.TransactionItem(TRNIT_id, TRNIT_transaction_at)';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_INVMV_TRNIT';

            PRINT N'            Expected Table                  : inventory.InventoryMovement';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @INVMV_TRNIT_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Columns                : INVMV_TRNIT_id, INVMV_TRNIT_transaction_at';
            PRINT N'            Actual Columns                  : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVMV_TRNIT_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : sales.TransactionItem(TRNIT_id, TRNIT_transaction_at)';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @INVMV_TRNIT_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Columns       : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVMV_TRNIT_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @INVMV_TRNIT_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @INVMV_TRNIT_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_TRNIT_FK_actual_is_disabled
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
                        @INVMV_TRNIT_FK_actual_is_not_trusted
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

            @INVMV_TRNIT_FK_equivalent_name =
                fk.name,

            @INVMV_TRNIT_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @INVMV_TRNIT_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @INVMV_TRNIT_FK_equivalent_is_disabled =
                fk.is_disabled,

            @INVMV_TRNIT_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.TransactionItem')

        AND fk.name <>
                @INVMV_TRNIT_FK_expected_name

        AND fk.delete_referential_action = 0

        AND fk.update_referential_action = 0

        AND
        (
            SELECT COUNT(*)

            FROM sys.foreign_key_columns AS fkc

            WHERE fkc.constraint_object_id =
                    fk.object_id

        ) = 2

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
                    N'INVMV_TRNIT_id'

            AND rc.name =
                    N'TRNIT_id'
        )

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

            AND fkc.constraint_column_id = 2

            AND pc.name =
                    N'INVMV_TRNIT_transaction_at'

            AND rc.name =
                    N'TRNIT_transaction_at'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @INVMV_TRNIT_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_INVMV_TRNIT';

            PRINT N'            Actual Name                    : '
                + @INVMV_TRNIT_FK_equivalent_name;

            PRINT N'            Columns                         : INVMV_TRNIT_id, INVMV_TRNIT_transaction_at';

            PRINT N'            References                     : sales.TransactionItem(TRNIT_id, TRNIT_transaction_at)';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @INVMV_TRNIT_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @INVMV_TRNIT_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_TRNIT_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMV_TRNIT_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'inventory.FK_INVMV_TRNIT', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @INVMV_TRNIT_FK_conflict_parent =
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
                            N'inventory.FK_INVMV_TRNIT',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_INVMV_TRNIT';
                PRINT N'            Expected Table                  : inventory.InventoryMovement';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @INVMV_TRNIT_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50958,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE inventory.InventoryMovement
                WITH CHECK
                ADD CONSTRAINT FK_INVMV_TRNIT
                FOREIGN KEY
                (
                    INVMV_TRNIT_id,
                    INVMV_TRNIT_transaction_at
                )
                REFERENCES sales.TransactionItem
                (
                    TRNIT_id,
                    TRNIT_transaction_at
                );


            ALTER TABLE inventory.InventoryMovement
                CHECK CONSTRAINT FK_INVMV_TRNIT;


            PRINT N'        [+] Foreign key constraint added    : FK_INVMV_TRNIT';
            PRINT N'            Columns                         : INVMV_TRNIT_id, INVMV_TRNIT_transaction_at';
            PRINT N'            References                      : sales.TransactionItem(TRNIT_id, TRNIT_transaction_at)';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';