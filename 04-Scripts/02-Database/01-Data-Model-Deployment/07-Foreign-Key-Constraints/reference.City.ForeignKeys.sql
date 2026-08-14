    PRINT N'    reference.City';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @CTY_FK_expected_name                sysname;
    DECLARE @CTY_FK_actual_name                  sysname;

    DECLARE @CTY_FK_actual_parent_table          nvarchar(517);
    DECLARE @CTY_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CTY_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CTY_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CTY_FK_actual_delete_action         nvarchar(60);
    DECLARE @CTY_FK_actual_update_action         nvarchar(60);

    DECLARE @CTY_FK_actual_is_disabled           bit;
    DECLARE @CTY_FK_actual_is_not_trusted        bit;

    DECLARE @CTY_FK_equivalent_name              sysname;
    DECLARE @CTY_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CTY_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CTY_FK_equivalent_is_disabled       bit;
    DECLARE @CTY_FK_equivalent_is_not_trusted    bit;

    DECLARE @CTY_FK_conflict_parent              nvarchar(517);


    SET @CTY_FK_expected_name = N'FK_CTY_ADV';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.City', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.City';

        ;THROW 50270,
            N'Foreign key FK_CTY_ADV cannot be deployed because reference.City does not exist.',
            1;

    END;


    IF OBJECT_ID(N'reference.AdministrativeDivision', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.AdministrativeDivision';

        ;THROW 50271,
            N'Foreign key FK_CTY_ADV cannot be deployed because reference.AdministrativeDivision does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.City', N'CTY_ADV_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CTY_ADV_id';

        ;THROW 50272,
            N'Foreign key FK_CTY_ADV cannot be deployed because CTY_ADV_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.AdministrativeDivision', N'ADV_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : ADV_id';

        ;THROW 50273,
            N'Foreign key FK_CTY_ADV cannot be deployed because referenced column reference.AdministrativeDivision.ADV_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CTY_ADV_id -> tinyint NOT NULL
            ADV_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'reference.AdministrativeDivision')

        WHERE parent_column.object_id =
                OBJECT_ID(N'reference.City')

        AND parent_column.name =
                N'CTY_ADV_id'

        AND referenced_column.name =
                N'ADV_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'tinyint'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'tinyint'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : CTY_ADV_id -> ADV_id';

        ;THROW 50274,
            N'Foreign key FK_CTY_ADV cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @CTY_FK_actual_name =
            fk.name,

        @CTY_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @CTY_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @CTY_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CTY_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CTY_FK_actual_is_disabled =
            fk.is_disabled,

        @CTY_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CTY_FK_actual_parent_columns =
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

        @CTY_FK_actual_referenced_columns =
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
            OBJECT_ID(N'reference.City')

    AND fk.name =
            @CTY_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @CTY_FK_actual_name IS NOT NULL
    BEGIN

        IF @CTY_FK_actual_parent_table =
                N'[reference].[City]'

        AND @CTY_FK_actual_parent_columns =
                N'CTY_ADV_id'

        AND @CTY_FK_actual_referenced_table =
                N'[reference].[AdministrativeDivision]'

        AND @CTY_FK_actual_referenced_columns =
                N'ADV_id'

        AND @CTY_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CTY_FK_actual_update_action =
                N'NO_ACTION'

        AND @CTY_FK_actual_is_disabled = 0

        AND @CTY_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CTY_ADV';
            PRINT N'            Column                          : CTY_ADV_id';
            PRINT N'            References                      : reference.AdministrativeDivision.ADV_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CTY_ADV';

            PRINT N'            Expected Table                  : reference.City';
            PRINT N'            Actual Table                    : '
                + COALESCE(@CTY_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : CTY_ADV_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CTY_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : reference.AdministrativeDivision.ADV_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@CTY_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CTY_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@CTY_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@CTY_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CTY_FK_actual_is_disabled
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
                        @CTY_FK_actual_is_not_trusted
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

            @CTY_FK_equivalent_name =
                fk.name,

            @CTY_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CTY_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CTY_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CTY_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'reference.City')

        AND fk.referenced_object_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND fk.name <>
                @CTY_FK_expected_name

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
                    N'CTY_ADV_id'

            AND rc.name =
                    N'ADV_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @CTY_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_CTY_ADV';

            PRINT N'            Actual Name                    : '
                + @CTY_FK_equivalent_name;

            PRINT N'            Column                         : CTY_ADV_id';

            PRINT N'            References                     : reference.AdministrativeDivision.ADV_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @CTY_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @CTY_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CTY_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CTY_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'reference.FK_CTY_ADV', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CTY_FK_conflict_parent =
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
                            N'reference.FK_CTY_ADV',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_CTY_ADV';
                PRINT N'            Expected Table                  : reference.City';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @CTY_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50275,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE reference.City
                WITH CHECK
                ADD CONSTRAINT FK_CTY_ADV
                FOREIGN KEY
                (
                    CTY_ADV_id
                )
                REFERENCES reference.AdministrativeDivision
                (
                    ADV_id
                );


            ALTER TABLE reference.City
                CHECK CONSTRAINT FK_CTY_ADV;


            PRINT N'        [+] Foreign key constraint added    : FK_CTY_ADV';
            PRINT N'            Column                          : CTY_ADV_id';
            PRINT N'            References                      : reference.AdministrativeDivision.ADV_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';