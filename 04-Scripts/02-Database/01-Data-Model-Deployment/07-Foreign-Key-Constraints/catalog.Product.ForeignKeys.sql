    PRINT N'';
    PRINT N'    ● catalog.Product';
    PRINT N'';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @PRD_FK_expected_name                sysname;
    DECLARE @PRD_FK_actual_name                  sysname;

    DECLARE @PRD_FK_actual_parent_table          nvarchar(517);
    DECLARE @PRD_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PRD_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PRD_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PRD_FK_actual_delete_action         nvarchar(60);
    DECLARE @PRD_FK_actual_update_action         nvarchar(60);

    DECLARE @PRD_FK_actual_is_disabled           bit;
    DECLARE @PRD_FK_actual_is_not_trusted        bit;

    DECLARE @PRD_FK_equivalent_name              sysname;
    DECLARE @PRD_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PRD_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PRD_FK_equivalent_is_disabled       bit;
    DECLARE @PRD_FK_equivalent_is_not_trusted    bit;

    DECLARE @PRD_FK_conflict_parent              nvarchar(517);


    SET @PRD_FK_expected_name = N'FK_PRD_BRD';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.Product', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.Product';

        ;THROW 50190,
            N'Foreign key FK_PRD_BRD cannot be deployed because catalog.Product does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.Brand', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.Brand';

        ;THROW 50191,
            N'Foreign key FK_PRD_BRD cannot be deployed because catalog.Brand does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.Product', N'PRD_BRD_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PRD_BRD_id';

        ;THROW 50192,
            N'Foreign key FK_PRD_BRD cannot be deployed because PRD_BRD_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.Brand', N'BRD_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : BRD_id';

        ;THROW 50193,
            N'Foreign key FK_PRD_BRD cannot be deployed because referenced column catalog.Brand.BRD_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PRD_BRD_id -> smallint NOT NULL
            BRD_id     -> smallint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.Brand')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.Product')

        AND parent_column.name =
                N'PRD_BRD_id'

        AND referenced_column.name =
                N'BRD_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PRD_BRD_id -> BRD_id';

        ;THROW 50194,
            N'Foreign key FK_PRD_BRD cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_PRD_BRD';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @PRD_FK_actual_name =
            fk.name,

        @PRD_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PRD_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PRD_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PRD_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PRD_FK_actual_is_disabled =
            fk.is_disabled,

        @PRD_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PRD_FK_actual_parent_columns =
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

        @PRD_FK_actual_referenced_columns =
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
            OBJECT_ID(N'catalog.Product')

    AND fk.name =
            @PRD_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @PRD_FK_actual_name IS NOT NULL
    BEGIN

        IF @PRD_FK_actual_parent_table =
                N'[catalog].[Product]'

        AND @PRD_FK_actual_parent_columns =
                N'PRD_BRD_id'

        AND @PRD_FK_actual_referenced_table =
                N'[catalog].[Brand]'

        AND @PRD_FK_actual_referenced_columns =
                N'BRD_id'

        AND @PRD_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PRD_FK_actual_update_action =
                N'NO_ACTION'

        AND @PRD_FK_actual_is_disabled = 0

        AND @PRD_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PRD_BRD';
            PRINT N'            Column                          : PRD_BRD_id';
            PRINT N'            References                      : catalog.Brand.BRD_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PRD_BRD';

            PRINT N'            Expected Table                  : catalog.Product';
            PRINT N'            Actual Table                    : '
                + COALESCE(@PRD_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : PRD_BRD_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRD_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.Brand.BRD_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@PRD_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PRD_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@PRD_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@PRD_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRD_FK_actual_is_disabled
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
                        @PRD_FK_actual_is_not_trusted
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

            @PRD_FK_equivalent_name =
                fk.name,

            @PRD_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PRD_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PRD_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PRD_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.Product')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.Brand')

        AND fk.name <>
                @PRD_FK_expected_name

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
                    N'PRD_BRD_id'

                AND rc.name =
                    N'BRD_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @PRD_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PRD_BRD';

            PRINT N'            Actual Name                    : '
                + @PRD_FK_equivalent_name;

            PRINT N'            Column                         : PRD_BRD_id';

            PRINT N'            References                     : catalog.Brand.BRD_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PRD_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PRD_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRD_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PRD_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'catalog.FK_PRD_BRD', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PRD_FK_conflict_parent =
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
                            N'catalog.FK_PRD_BRD',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PRD_BRD';
                PRINT N'            Expected Table                  : catalog.Product';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PRD_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50195,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE catalog.Product
                WITH CHECK
                ADD CONSTRAINT FK_PRD_BRD
                FOREIGN KEY
                (
                    PRD_BRD_id
                )
                REFERENCES catalog.Brand
                (
                    BRD_id
                );


            ALTER TABLE catalog.Product
                CHECK CONSTRAINT FK_PRD_BRD;


            PRINT N'        [+] Foreign key constraint added    : FK_PRD_BRD';
            PRINT N'            Column                          : PRD_BRD_id';
            PRINT N'            References                      : catalog.Brand.BRD_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';