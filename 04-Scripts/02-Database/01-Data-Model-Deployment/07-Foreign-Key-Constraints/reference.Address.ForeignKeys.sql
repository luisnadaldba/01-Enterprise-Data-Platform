    PRINT N'';
    PRINT N'    ● reference.Address';
    PRINT N'';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @ADR_FK_expected_name                sysname;
    DECLARE @ADR_FK_actual_name                  sysname;

    DECLARE @ADR_FK_actual_parent_table          nvarchar(517);
    DECLARE @ADR_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @ADR_FK_actual_referenced_table      nvarchar(517);
    DECLARE @ADR_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @ADR_FK_actual_delete_action         nvarchar(60);
    DECLARE @ADR_FK_actual_update_action         nvarchar(60);

    DECLARE @ADR_FK_actual_is_disabled           bit;
    DECLARE @ADR_FK_actual_is_not_trusted        bit;

    DECLARE @ADR_FK_equivalent_name              sysname;
    DECLARE @ADR_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @ADR_FK_equivalent_update_action     nvarchar(60);
    DECLARE @ADR_FK_equivalent_is_disabled       bit;
    DECLARE @ADR_FK_equivalent_is_not_trusted    bit;

    DECLARE @ADR_FK_conflict_parent              nvarchar(517);


    SET @ADR_FK_expected_name = N'FK_ADR_CTY';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.Address', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.Address';

        ;THROW 50240,
            N'Foreign key FK_ADR_CTY cannot be deployed because reference.Address does not exist.',
            1;

    END;


    IF OBJECT_ID(N'reference.City', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.City';

        ;THROW 50241,
            N'Foreign key FK_ADR_CTY cannot be deployed because reference.City does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.Address', N'ADR_CTY_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : ADR_CTY_id';

        ;THROW 50242,
            N'Foreign key FK_ADR_CTY cannot be deployed because ADR_CTY_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.City', N'CTY_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CTY_id';

        ;THROW 50243,
            N'Foreign key FK_ADR_CTY cannot be deployed because referenced column reference.City.CTY_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            ADR_CTY_id -> int NOT NULL
            CTY_id     -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'reference.City')

        WHERE parent_column.object_id =
                OBJECT_ID(N'reference.Address')

        AND parent_column.name =
                N'ADR_CTY_id'

        AND referenced_column.name =
                N'CTY_id'

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

        PRINT N'        [X] Foreign key column mismatch    : ADR_CTY_id -> CTY_id';

        ;THROW 50244,
            N'Foreign key FK_ADR_CTY cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_ADR_CTY';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @ADR_FK_actual_name =
            fk.name,

        @ADR_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @ADR_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @ADR_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @ADR_FK_actual_update_action =
            fk.update_referential_action_desc,

        @ADR_FK_actual_is_disabled =
            fk.is_disabled,

        @ADR_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @ADR_FK_actual_parent_columns =
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

        @ADR_FK_actual_referenced_columns =
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
            OBJECT_ID(N'reference.Address')

    AND fk.name =
            @ADR_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @ADR_FK_actual_name IS NOT NULL
    BEGIN

        IF @ADR_FK_actual_parent_table =
                N'[reference].[Address]'

        AND @ADR_FK_actual_parent_columns =
                N'ADR_CTY_id'

        AND @ADR_FK_actual_referenced_table =
                N'[reference].[City]'

        AND @ADR_FK_actual_referenced_columns =
                N'CTY_id'

        AND @ADR_FK_actual_delete_action =
                N'NO_ACTION'

        AND @ADR_FK_actual_update_action =
                N'NO_ACTION'

        AND @ADR_FK_actual_is_disabled = 0

        AND @ADR_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_ADR_CTY';
            PRINT N'            Column                          : ADR_CTY_id';
            PRINT N'            References                      : reference.City.CTY_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_ADR_CTY';

            PRINT N'            Expected Table                  : reference.Address';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @ADR_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : ADR_CTY_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @ADR_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : reference.City.CTY_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @ADR_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @ADR_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @ADR_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @ADR_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @ADR_FK_actual_is_disabled
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
                        @ADR_FK_actual_is_not_trusted
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

            @ADR_FK_equivalent_name =
                fk.name,

            @ADR_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @ADR_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @ADR_FK_equivalent_is_disabled =
                fk.is_disabled,

            @ADR_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'reference.Address')

        AND fk.referenced_object_id =
                OBJECT_ID(N'reference.City')

        AND fk.name <>
                @ADR_FK_expected_name

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
                    N'ADR_CTY_id'

            AND rc.name =
                    N'CTY_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @ADR_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_ADR_CTY';

            PRINT N'            Actual Name                    : '
                + @ADR_FK_equivalent_name;

            PRINT N'            Column                         : ADR_CTY_id';

            PRINT N'            References                     : reference.City.CTY_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @ADR_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @ADR_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @ADR_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @ADR_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'reference.FK_ADR_CTY', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @ADR_FK_conflict_parent =
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
                            N'reference.FK_ADR_CTY',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_ADR_CTY';
                PRINT N'            Expected Table                  : reference.Address';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @ADR_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50245,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE reference.Address
                WITH CHECK
                ADD CONSTRAINT FK_ADR_CTY
                FOREIGN KEY
                (
                    ADR_CTY_id
                )
                REFERENCES reference.City
                (
                    CTY_id
                );


            ALTER TABLE reference.Address
                CHECK CONSTRAINT FK_ADR_CTY;


            PRINT N'        [+] Foreign key constraint added    : FK_ADR_CTY';
            PRINT N'            Column                          : ADR_CTY_id';
            PRINT N'            References                      : reference.City.CTY_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';