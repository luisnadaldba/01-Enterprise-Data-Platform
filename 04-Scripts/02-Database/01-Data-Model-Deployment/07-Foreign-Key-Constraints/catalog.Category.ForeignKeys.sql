    PRINT N'    catalog.Category';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @CTG_FK_expected_name                sysname;
    DECLARE @CTG_FK_actual_name                  sysname;

    DECLARE @CTG_FK_actual_parent_table          nvarchar(517);
    DECLARE @CTG_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CTG_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CTG_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CTG_FK_actual_delete_action         nvarchar(60);
    DECLARE @CTG_FK_actual_update_action         nvarchar(60);

    DECLARE @CTG_FK_actual_is_disabled           bit;
    DECLARE @CTG_FK_actual_is_not_trusted        bit;

    DECLARE @CTG_FK_equivalent_name              sysname;
    DECLARE @CTG_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CTG_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CTG_FK_equivalent_is_disabled       bit;
    DECLARE @CTG_FK_equivalent_is_not_trusted    bit;

    DECLARE @CTG_FK_conflict_parent              nvarchar(517);


    SET @CTG_FK_expected_name = N'FK_CTG_CTG';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.Category', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.Category';

        ;THROW 50160,
            N'Foreign key FK_CTG_CTG cannot be deployed because catalog.Category does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.Category', N'CTG_CTG_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CTG_CTG_id';

        ;THROW 50161,
            N'Foreign key FK_CTG_CTG cannot be deployed because CTG_CTG_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.Category', N'CTG_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CTG_id';

        ;THROW 50162,
            N'Foreign key FK_CTG_CTG cannot be deployed because referenced column CTG_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CTG_CTG_id -> smallint NULL
            CTG_id     -> smallint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.Category')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.Category')

        AND parent_column.name =
                N'CTG_CTG_id'

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

        PRINT N'        [X] Foreign key column mismatch    : CTG_CTG_id -> CTG_id';

        ;THROW 50163,
            N'Foreign key FK_CTG_CTG cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @CTG_FK_actual_name =
            fk.name,

        @CTG_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @CTG_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @CTG_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CTG_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CTG_FK_actual_is_disabled =
            fk.is_disabled,

        @CTG_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CTG_FK_actual_parent_columns =
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

        @CTG_FK_actual_referenced_columns =
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
            OBJECT_ID(N'catalog.Category')

    AND fk.name =
            @CTG_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @CTG_FK_actual_name IS NOT NULL
    BEGIN

        IF @CTG_FK_actual_parent_table =
                N'[catalog].[Category]'

        AND @CTG_FK_actual_parent_columns =
                N'CTG_CTG_id'

        AND @CTG_FK_actual_referenced_table =
                N'[catalog].[Category]'

        AND @CTG_FK_actual_referenced_columns =
                N'CTG_id'

        AND @CTG_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CTG_FK_actual_update_action =
                N'NO_ACTION'

        AND @CTG_FK_actual_is_disabled = 0

        AND @CTG_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CTG_CTG';
            PRINT N'            Column                          : CTG_CTG_id';
            PRINT N'            References                      : catalog.Category.CTG_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CTG_CTG';

            PRINT N'            Expected Table                  : catalog.Category';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @CTG_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : CTG_CTG_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CTG_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.Category.CTG_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @CTG_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CTG_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @CTG_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @CTG_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CTG_FK_actual_is_disabled
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
                        @CTG_FK_actual_is_not_trusted
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

            @CTG_FK_equivalent_name =
                fk.name,

            @CTG_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CTG_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CTG_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CTG_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.Category')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.Category')

        AND fk.name <>
                @CTG_FK_expected_name

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
                    N'CTG_CTG_id'

            AND rc.name =
                    N'CTG_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @CTG_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_CTG_CTG';

            PRINT N'            Actual Name                    : '
                + @CTG_FK_equivalent_name;

            PRINT N'            Column                         : CTG_CTG_id';

            PRINT N'            References                     : catalog.Category.CTG_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @CTG_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @CTG_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CTG_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CTG_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'catalog.FK_CTG_CTG', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CTG_FK_conflict_parent =
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
                            N'catalog.FK_CTG_CTG',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_CTG_CTG';
                PRINT N'            Expected Table                  : catalog.Category';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @CTG_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50164,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE catalog.Category
                WITH CHECK
                ADD CONSTRAINT FK_CTG_CTG
                FOREIGN KEY
                (
                    CTG_CTG_id
                )
                REFERENCES catalog.Category
                (
                    CTG_id
                );


            ALTER TABLE catalog.Category
                CHECK CONSTRAINT FK_CTG_CTG;


            PRINT N'        [+] Foreign key constraint added    : FK_CTG_CTG';
            PRINT N'            Column                          : CTG_CTG_id';
            PRINT N'            References                      : catalog.Category.CTG_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';