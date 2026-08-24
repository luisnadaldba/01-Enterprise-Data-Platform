    PRINT N'';
    PRINT N'    ● reference.AdministrativeDivision';
    PRINT N'';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @ADV_FK_expected_name                sysname;
    DECLARE @ADV_FK_actual_name                  sysname;

    DECLARE @ADV_FK_actual_parent_table          nvarchar(517);
    DECLARE @ADV_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @ADV_FK_actual_referenced_table      nvarchar(517);
    DECLARE @ADV_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @ADV_FK_actual_delete_action         nvarchar(60);
    DECLARE @ADV_FK_actual_update_action         nvarchar(60);

    DECLARE @ADV_FK_actual_is_disabled           bit;
    DECLARE @ADV_FK_actual_is_not_trusted        bit;

    DECLARE @ADV_FK_equivalent_name              sysname;
    DECLARE @ADV_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @ADV_FK_equivalent_update_action     nvarchar(60);
    DECLARE @ADV_FK_equivalent_is_disabled       bit;
    DECLARE @ADV_FK_equivalent_is_not_trusted    bit;

    DECLARE @ADV_FK_conflict_parent              nvarchar(517);


    SET @ADV_FK_expected_name = N'FK_ADV_CTR';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.AdministrativeDivision', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.AdministrativeDivision';

        ;THROW 50290,
            N'Foreign key FK_ADV_CTR cannot be deployed because reference.AdministrativeDivision does not exist.',
            1;

    END;


    IF OBJECT_ID(N'reference.Country', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.Country';

        ;THROW 50291,
            N'Foreign key FK_ADV_CTR cannot be deployed because reference.Country does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.AdministrativeDivision', N'ADV_CTR_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : ADV_CTR_id';

        ;THROW 50292,
            N'Foreign key FK_ADV_CTR cannot be deployed because ADV_CTR_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.Country', N'CTR_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CTR_id';

        ;THROW 50293,
            N'Foreign key FK_ADV_CTR cannot be deployed because referenced column reference.Country.CTR_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            ADV_CTR_id -> tinyint NOT NULL
            CTR_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'reference.Country')

        WHERE parent_column.object_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND parent_column.name =
                N'ADV_CTR_id'

        AND referenced_column.name =
                N'CTR_id'

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

        PRINT N'        [X] Foreign key column mismatch    : ADV_CTR_id -> CTR_id';

        ;THROW 50294,
            N'Foreign key FK_ADV_CTR cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_ADV_CTR';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @ADV_FK_actual_name =
            fk.name,

        @ADV_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @ADV_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @ADV_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @ADV_FK_actual_update_action =
            fk.update_referential_action_desc,

        @ADV_FK_actual_is_disabled =
            fk.is_disabled,

        @ADV_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @ADV_FK_actual_parent_columns =
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

        @ADV_FK_actual_referenced_columns =
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
            OBJECT_ID(N'reference.AdministrativeDivision')

    AND fk.name =
            @ADV_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @ADV_FK_actual_name IS NOT NULL
    BEGIN

        IF @ADV_FK_actual_parent_table =
                N'[reference].[AdministrativeDivision]'

        AND @ADV_FK_actual_parent_columns =
                N'ADV_CTR_id'

        AND @ADV_FK_actual_referenced_table =
                N'[reference].[Country]'

        AND @ADV_FK_actual_referenced_columns =
                N'CTR_id'

        AND @ADV_FK_actual_delete_action =
                N'NO_ACTION'

        AND @ADV_FK_actual_update_action =
                N'NO_ACTION'

        AND @ADV_FK_actual_is_disabled = 0

        AND @ADV_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_ADV_CTR';
            PRINT N'            Column                          : ADV_CTR_id';
            PRINT N'            References                      : reference.Country.CTR_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_ADV_CTR';

            PRINT N'            Expected Table                  : reference.AdministrativeDivision';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @ADV_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : ADV_CTR_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @ADV_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : reference.Country.CTR_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @ADV_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @ADV_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @ADV_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @ADV_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @ADV_FK_actual_is_disabled
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
                        @ADV_FK_actual_is_not_trusted
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

            @ADV_FK_equivalent_name =
                fk.name,

            @ADV_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @ADV_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @ADV_FK_equivalent_is_disabled =
                fk.is_disabled,

            @ADV_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND fk.referenced_object_id =
                OBJECT_ID(N'reference.Country')

        AND fk.name <>
                @ADV_FK_expected_name

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
                    N'ADV_CTR_id'

            AND rc.name =
                    N'CTR_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @ADV_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_ADV_CTR';

            PRINT N'            Actual Name                    : '
                + @ADV_FK_equivalent_name;

            PRINT N'            Column                         : ADV_CTR_id';

            PRINT N'            References                     : reference.Country.CTR_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @ADV_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @ADV_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @ADV_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @ADV_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'reference.FK_ADV_CTR', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @ADV_FK_conflict_parent =
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
                            N'reference.FK_ADV_CTR',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_ADV_CTR';
                PRINT N'            Expected Table                  : reference.AdministrativeDivision';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @ADV_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50295,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE reference.AdministrativeDivision
                WITH CHECK
                ADD CONSTRAINT FK_ADV_CTR
                FOREIGN KEY
                (
                    ADV_CTR_id
                )
                REFERENCES reference.Country
                (
                    CTR_id
                );


            ALTER TABLE reference.AdministrativeDivision
                CHECK CONSTRAINT FK_ADV_CTR;


            PRINT N'        [+] Foreign key constraint added    : FK_ADV_CTR';
            PRINT N'            Column                          : ADV_CTR_id';
            PRINT N'            References                      : reference.Country.CTR_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';