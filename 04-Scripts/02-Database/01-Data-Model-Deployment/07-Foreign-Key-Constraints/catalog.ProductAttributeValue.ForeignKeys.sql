    PRINT N'    catalog.ProductAttributeValue';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @PATVL_FK_expected_name                sysname;
    DECLARE @PATVL_FK_actual_name                  sysname;

    DECLARE @PATVL_FK_actual_parent_table          nvarchar(517);
    DECLARE @PATVL_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @PATVL_FK_actual_referenced_table      nvarchar(517);
    DECLARE @PATVL_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @PATVL_FK_actual_delete_action         nvarchar(60);
    DECLARE @PATVL_FK_actual_update_action         nvarchar(60);

    DECLARE @PATVL_FK_actual_is_disabled           bit;
    DECLARE @PATVL_FK_actual_is_not_trusted        bit;

    DECLARE @PATVL_FK_equivalent_name              sysname;
    DECLARE @PATVL_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @PATVL_FK_equivalent_update_action     nvarchar(60);
    DECLARE @PATVL_FK_equivalent_is_disabled       bit;
    DECLARE @PATVL_FK_equivalent_is_not_trusted    bit;

    DECLARE @PATVL_FK_conflict_parent              nvarchar(517);


    SET @PATVL_FK_expected_name = N'FK_PATVL_PAT';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'catalog.ProductAttributeValue', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductAttributeValue';

        ;THROW 50260,
            N'Foreign key FK_PATVL_PAT cannot be deployed because catalog.ProductAttributeValue does not exist.',
            1;

    END;


    IF OBJECT_ID(N'catalog.ProductAttribute', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : catalog.ProductAttribute';

        ;THROW 50261,
            N'Foreign key FK_PATVL_PAT cannot be deployed because catalog.ProductAttribute does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductAttributeValue', N'PATVL_PAT_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : PATVL_PAT_id';

        ;THROW 50262,
            N'Foreign key FK_PATVL_PAT cannot be deployed because PATVL_PAT_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'catalog.ProductAttribute', N'PAT_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : PAT_id';

        ;THROW 50263,
            N'Foreign key FK_PATVL_PAT cannot be deployed because referenced column catalog.ProductAttribute.PAT_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            PATVL_PAT_id -> int NOT NULL
            PAT_id       -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'catalog.ProductAttribute')

        WHERE parent_column.object_id =
                OBJECT_ID(N'catalog.ProductAttributeValue')

        AND parent_column.name =
                N'PATVL_PAT_id'

        AND referenced_column.name =
                N'PAT_id'

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

        PRINT N'        [X] Foreign key column mismatch    : PATVL_PAT_id -> PAT_id';

        ;THROW 50264,
            N'Foreign key FK_PATVL_PAT cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @PATVL_FK_actual_name =
            fk.name,

        @PATVL_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @PATVL_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @PATVL_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @PATVL_FK_actual_update_action =
            fk.update_referential_action_desc,

        @PATVL_FK_actual_is_disabled =
            fk.is_disabled,

        @PATVL_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @PATVL_FK_actual_parent_columns =
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

        @PATVL_FK_actual_referenced_columns =
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
            OBJECT_ID(N'catalog.ProductAttributeValue')

    AND fk.name =
            @PATVL_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @PATVL_FK_actual_name IS NOT NULL
    BEGIN

        IF @PATVL_FK_actual_parent_table =
                N'[catalog].[ProductAttributeValue]'

        AND @PATVL_FK_actual_parent_columns =
                N'PATVL_PAT_id'

        AND @PATVL_FK_actual_referenced_table =
                N'[catalog].[ProductAttribute]'

        AND @PATVL_FK_actual_referenced_columns =
                N'PAT_id'

        AND @PATVL_FK_actual_delete_action =
                N'NO_ACTION'

        AND @PATVL_FK_actual_update_action =
                N'NO_ACTION'

        AND @PATVL_FK_actual_is_disabled = 0

        AND @PATVL_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_PATVL_PAT';
            PRINT N'            Column                          : PATVL_PAT_id';
            PRINT N'            References                      : catalog.ProductAttribute.PAT_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_PATVL_PAT';

            PRINT N'            Expected Table                  : catalog.ProductAttributeValue';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @PATVL_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : PATVL_PAT_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PATVL_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : catalog.ProductAttribute.PAT_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @PATVL_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @PATVL_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @PATVL_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @PATVL_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PATVL_FK_actual_is_disabled
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
                        @PATVL_FK_actual_is_not_trusted
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

            @PATVL_FK_equivalent_name =
                fk.name,

            @PATVL_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @PATVL_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @PATVL_FK_equivalent_is_disabled =
                fk.is_disabled,

            @PATVL_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'catalog.ProductAttributeValue')

        AND fk.referenced_object_id =
                OBJECT_ID(N'catalog.ProductAttribute')

        AND fk.name <>
                @PATVL_FK_expected_name

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
                    N'PATVL_PAT_id'

            AND rc.name =
                    N'PAT_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @PATVL_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_PATVL_PAT';

            PRINT N'            Actual Name                    : '
                + @PATVL_FK_equivalent_name;

            PRINT N'            Column                         : PATVL_PAT_id';

            PRINT N'            References                     : catalog.ProductAttribute.PAT_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @PATVL_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @PATVL_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PATVL_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @PATVL_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'catalog.FK_PATVL_PAT', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @PATVL_FK_conflict_parent =
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
                            N'catalog.FK_PATVL_PAT',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_PATVL_PAT';
                PRINT N'            Expected Table                  : catalog.ProductAttributeValue';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @PATVL_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50265,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE catalog.ProductAttributeValue
                WITH CHECK
                ADD CONSTRAINT FK_PATVL_PAT
                FOREIGN KEY
                (
                    PATVL_PAT_id
                )
                REFERENCES catalog.ProductAttribute
                (
                    PAT_id
                );


            ALTER TABLE catalog.ProductAttributeValue
                CHECK CONSTRAINT FK_PATVL_PAT;


            PRINT N'        [+] Foreign key constraint added    : FK_PATVL_PAT';
            PRINT N'            Column                          : PATVL_PAT_id';
            PRINT N'            References                      : catalog.ProductAttribute.PAT_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';