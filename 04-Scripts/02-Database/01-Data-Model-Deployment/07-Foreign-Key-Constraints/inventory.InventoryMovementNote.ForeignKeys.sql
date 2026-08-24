    PRINT N'';
    PRINT N'    ● inventory.InventoryMovementNote';
    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_INVMN_INVMV
    ==============================================================================*/

    DECLARE @INVMN_INVMV_FK_expected_name                sysname;
    DECLARE @INVMN_INVMV_FK_actual_name                  sysname;

    DECLARE @INVMN_INVMV_FK_actual_parent_table          nvarchar(517);
    DECLARE @INVMN_INVMV_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @INVMN_INVMV_FK_actual_referenced_table      nvarchar(517);
    DECLARE @INVMN_INVMV_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @INVMN_INVMV_FK_actual_delete_action         nvarchar(60);
    DECLARE @INVMN_INVMV_FK_actual_update_action         nvarchar(60);

    DECLARE @INVMN_INVMV_FK_actual_is_disabled           bit;
    DECLARE @INVMN_INVMV_FK_actual_is_not_trusted        bit;

    DECLARE @INVMN_INVMV_FK_equivalent_name              sysname;
    DECLARE @INVMN_INVMV_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @INVMN_INVMV_FK_equivalent_update_action     nvarchar(60);
    DECLARE @INVMN_INVMV_FK_equivalent_is_disabled       bit;
    DECLARE @INVMN_INVMV_FK_equivalent_is_not_trusted    bit;

    DECLARE @INVMN_INVMV_FK_conflict_parent              nvarchar(517);


    SET @INVMN_INVMV_FK_expected_name = N'FK_INVMN_INVMV';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'inventory.InventoryMovementNote', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryMovementNote';

        ;THROW 51020,
            N'Foreign key FK_INVMN_INVMV cannot be deployed because inventory.InventoryMovementNote does not exist.',
            1;

    END;


    IF OBJECT_ID(N'inventory.InventoryMovement', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : inventory.InventoryMovement';

        ;THROW 51021,
            N'Foreign key FK_INVMN_INVMV cannot be deployed because inventory.InventoryMovement does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryMovementNote', N'INVMN_INVMV_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : INVMN_INVMV_id';

        ;THROW 51022,
            N'Foreign key FK_INVMN_INVMV cannot be deployed because INVMN_INVMV_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'inventory.InventoryMovement', N'INVMV_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : INVMV_id';

        ;THROW 51023,
            N'Foreign key FK_INVMN_INVMV cannot be deployed because referenced column inventory.InventoryMovement.INVMV_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            INVMN_INVMV_id -> bigint NOT NULL
            INVMV_id       -> bigint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'inventory.InventoryMovement')

        WHERE parent_column.object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND parent_column.name =
                N'INVMN_INVMV_id'

        AND referenced_column.name =
                N'INVMV_id'

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

        PRINT N'        [X] Foreign key column mismatch    : INVMN_INVMV_id -> INVMV_id';

        ;THROW 51024,
            N'Foreign key FK_INVMN_INVMV cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_INVMN_INVMV';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @INVMN_INVMV_FK_actual_name =
            fk.name,

        @INVMN_INVMV_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @INVMN_INVMV_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @INVMN_INVMV_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @INVMN_INVMV_FK_actual_update_action =
            fk.update_referential_action_desc,

        @INVMN_INVMV_FK_actual_is_disabled =
            fk.is_disabled,

        @INVMN_INVMV_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @INVMN_INVMV_FK_actual_parent_columns =
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

        @INVMN_INVMV_FK_actual_referenced_columns =
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
            OBJECT_ID(N'inventory.InventoryMovementNote')

    AND fk.name =
            @INVMN_INVMV_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @INVMN_INVMV_FK_actual_name IS NOT NULL
    BEGIN

        IF @INVMN_INVMV_FK_actual_parent_table =
                N'[inventory].[InventoryMovementNote]'

        AND @INVMN_INVMV_FK_actual_parent_columns =
                N'INVMN_INVMV_id'

        AND @INVMN_INVMV_FK_actual_referenced_table =
                N'[inventory].[InventoryMovement]'

        AND @INVMN_INVMV_FK_actual_referenced_columns =
                N'INVMV_id'

        AND @INVMN_INVMV_FK_actual_delete_action =
                N'NO_ACTION'

        AND @INVMN_INVMV_FK_actual_update_action =
                N'NO_ACTION'

        AND @INVMN_INVMV_FK_actual_is_disabled = 0

        AND @INVMN_INVMV_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_INVMN_INVMV';
            PRINT N'            Column                          : INVMN_INVMV_id';
            PRINT N'            References                      : inventory.InventoryMovement.INVMV_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_INVMN_INVMV';

            PRINT N'            Expected Table                  : inventory.InventoryMovementNote';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @INVMN_INVMV_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : INVMN_INVMV_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVMN_INVMV_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : inventory.InventoryMovement.INVMV_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @INVMN_INVMV_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @INVMN_INVMV_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @INVMN_INVMV_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @INVMN_INVMV_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMN_INVMV_FK_actual_is_disabled
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
                        @INVMN_INVMV_FK_actual_is_not_trusted
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

            @INVMN_INVMV_FK_equivalent_name =
                fk.name,

            @INVMN_INVMV_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @INVMN_INVMV_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @INVMN_INVMV_FK_equivalent_is_disabled =
                fk.is_disabled,

            @INVMN_INVMV_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'inventory.InventoryMovementNote')

        AND fk.referenced_object_id =
                OBJECT_ID(N'inventory.InventoryMovement')

        AND fk.name <>
                @INVMN_INVMV_FK_expected_name

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
                    N'INVMN_INVMV_id'

            AND rc.name =
                    N'INVMV_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @INVMN_INVMV_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_INVMN_INVMV';

            PRINT N'            Actual Name                    : '
                + @INVMN_INVMV_FK_equivalent_name;

            PRINT N'            Column                         : INVMN_INVMV_id';

            PRINT N'            References                     : inventory.InventoryMovement.INVMV_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @INVMN_INVMV_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @INVMN_INVMV_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMN_INVMV_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @INVMN_INVMV_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'inventory.FK_INVMN_INVMV', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @INVMN_INVMV_FK_conflict_parent =
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
                            N'inventory.FK_INVMN_INVMV',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_INVMN_INVMV';
                PRINT N'            Expected Table                  : inventory.InventoryMovementNote';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @INVMN_INVMV_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 51025,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE inventory.InventoryMovementNote
                WITH CHECK
                ADD CONSTRAINT FK_INVMN_INVMV
                FOREIGN KEY
                (
                    INVMN_INVMV_id
                )
                REFERENCES inventory.InventoryMovement
                (
                    INVMV_id
                );


            ALTER TABLE inventory.InventoryMovementNote
                CHECK CONSTRAINT FK_INVMN_INVMV;


            PRINT N'        [+] Foreign key constraint added    : FK_INVMN_INVMV';
            PRINT N'            Column                          : INVMN_INVMV_id';
            PRINT N'            References                      : inventory.InventoryMovement.INVMV_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';