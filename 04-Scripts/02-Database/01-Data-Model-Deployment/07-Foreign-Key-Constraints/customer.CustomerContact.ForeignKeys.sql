    PRINT N'';
    PRINT N'    ● customer.CustomerContact';
    PRINT N'';


    /*==========================================================================
        FOREIGN KEY VARIABLES
    ==========================================================================*/

    DECLARE @CSTCN_CST_FK_expected_name                sysname;
    DECLARE @CSTCN_CST_FK_actual_name                  sysname;

    DECLARE @CSTCN_CST_FK_actual_parent_table          nvarchar(517);
    DECLARE @CSTCN_CST_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CSTCN_CST_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CSTCN_CST_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CSTCN_CST_FK_actual_delete_action         nvarchar(60);
    DECLARE @CSTCN_CST_FK_actual_update_action         nvarchar(60);

    DECLARE @CSTCN_CST_FK_actual_is_disabled           bit;
    DECLARE @CSTCN_CST_FK_actual_is_not_trusted        bit;

    DECLARE @CSTCN_CST_FK_equivalent_name              sysname;
    DECLARE @CSTCN_CST_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CSTCN_CST_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CSTCN_CST_FK_equivalent_is_disabled       bit;
    DECLARE @CSTCN_CST_FK_equivalent_is_not_trusted    bit;

    DECLARE @CSTCN_CST_FK_conflict_parent              nvarchar(517);


    SET @CSTCN_CST_FK_expected_name = N'FK_CSTCN_CST';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'customer.CustomerContact', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.CustomerContact';

        ;THROW 50660,
            N'Foreign key FK_CSTCN_CST cannot be deployed because customer.CustomerContact does not exist.',
            1;

    END;


    IF OBJECT_ID(N'customer.Customer', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.Customer';

        ;THROW 50661,
            N'Foreign key FK_CSTCN_CST cannot be deployed because customer.Customer does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerContact', N'CSTCN_CST_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CSTCN_CST_id';

        ;THROW 50662,
            N'Foreign key FK_CSTCN_CST cannot be deployed because CSTCN_CST_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.Customer', N'CST_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CST_id';

        ;THROW 50663,
            N'Foreign key FK_CSTCN_CST cannot be deployed because referenced column customer.Customer.CST_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CSTCN_CST_id -> int NOT NULL
            CST_id       -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'customer.Customer')

        WHERE parent_column.object_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND parent_column.name =
                N'CSTCN_CST_id'

        AND referenced_column.name =
                N'CST_id'

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

        PRINT N'        [X] Foreign key column mismatch    : CSTCN_CST_id -> CST_id';

        ;THROW 50664,
            N'Foreign key FK_CSTCN_CST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_CSTCN_CST';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @CSTCN_CST_FK_actual_name =
            fk.name,

        @CSTCN_CST_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @CSTCN_CST_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @CSTCN_CST_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CSTCN_CST_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CSTCN_CST_FK_actual_is_disabled =
            fk.is_disabled,

        @CSTCN_CST_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CSTCN_CST_FK_actual_parent_columns =
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

        @CSTCN_CST_FK_actual_referenced_columns =
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
            OBJECT_ID(N'customer.CustomerContact')

    AND fk.name =
            @CSTCN_CST_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @CSTCN_CST_FK_actual_name IS NOT NULL
    BEGIN

        IF @CSTCN_CST_FK_actual_parent_table =
                N'[customer].[CustomerContact]'

        AND @CSTCN_CST_FK_actual_parent_columns =
                N'CSTCN_CST_id'

        AND @CSTCN_CST_FK_actual_referenced_table =
                N'[customer].[Customer]'

        AND @CSTCN_CST_FK_actual_referenced_columns =
                N'CST_id'

        AND @CSTCN_CST_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CSTCN_CST_FK_actual_update_action =
                N'NO_ACTION'

        AND @CSTCN_CST_FK_actual_is_disabled = 0

        AND @CSTCN_CST_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CSTCN_CST';
            PRINT N'            Column                          : CSTCN_CST_id';
            PRINT N'            References                      : customer.Customer.CST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CSTCN_CST';

            PRINT N'            Expected Table                  : customer.CustomerContact';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @CSTCN_CST_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : CSTCN_CST_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CSTCN_CST_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : customer.Customer.CST_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @CSTCN_CST_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CSTCN_CST_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @CSTCN_CST_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @CSTCN_CST_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CSTCN_CST_FK_actual_is_disabled
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
                        @CSTCN_CST_FK_actual_is_not_trusted
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

            @CSTCN_CST_FK_equivalent_name =
                fk.name,

            @CSTCN_CST_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CSTCN_CST_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CSTCN_CST_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CSTCN_CST_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.name <>
                @CSTCN_CST_FK_expected_name

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
                    N'CSTCN_CST_id'

            AND rc.name =
                    N'CST_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @CSTCN_CST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_CSTCN_CST';

            PRINT N'            Actual Name                    : '
                + @CSTCN_CST_FK_equivalent_name;

            PRINT N'            Column                         : CSTCN_CST_id';

            PRINT N'            References                     : customer.Customer.CST_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @CSTCN_CST_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @CSTCN_CST_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CSTCN_CST_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CSTCN_CST_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'customer.FK_CSTCN_CST', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CSTCN_CST_FK_conflict_parent =
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
                            N'customer.FK_CSTCN_CST',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_CSTCN_CST';
                PRINT N'            Expected Table                  : customer.CustomerContact';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @CSTCN_CST_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50665,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE customer.CustomerContact
                WITH CHECK
                ADD CONSTRAINT FK_CSTCN_CST
                FOREIGN KEY
                (
                    CSTCN_CST_id
                )
                REFERENCES customer.Customer
                (
                    CST_id
                );


            ALTER TABLE customer.CustomerContact
                CHECK CONSTRAINT FK_CSTCN_CST;


            PRINT N'        [+] Foreign key constraint added    : FK_CSTCN_CST';
            PRINT N'            Column                          : CSTCN_CST_id';
            PRINT N'            References                      : customer.Customer.CST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_CSTCN_CTP
    ==============================================================================*/

    DECLARE @CSTCN_CTP_FK_expected_name                sysname;
    DECLARE @CSTCN_CTP_FK_actual_name                  sysname;

    DECLARE @CSTCN_CTP_FK_actual_parent_table          nvarchar(517);
    DECLARE @CSTCN_CTP_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CSTCN_CTP_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CSTCN_CTP_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CSTCN_CTP_FK_actual_delete_action         nvarchar(60);
    DECLARE @CSTCN_CTP_FK_actual_update_action         nvarchar(60);

    DECLARE @CSTCN_CTP_FK_actual_is_disabled           bit;
    DECLARE @CSTCN_CTP_FK_actual_is_not_trusted        bit;

    DECLARE @CSTCN_CTP_FK_equivalent_name              sysname;
    DECLARE @CSTCN_CTP_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CSTCN_CTP_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CSTCN_CTP_FK_equivalent_is_disabled       bit;
    DECLARE @CSTCN_CTP_FK_equivalent_is_not_trusted    bit;

    DECLARE @CSTCN_CTP_FK_conflict_parent              nvarchar(517);


    SET @CSTCN_CTP_FK_expected_name = N'FK_CSTCN_CTP';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'reference.ContactType', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.ContactType';

        ;THROW 50666,
            N'Foreign key FK_CSTCN_CTP cannot be deployed because reference.ContactType does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerContact', N'CSTCN_CTP_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CSTCN_CTP_id';

        ;THROW 50667,
            N'Foreign key FK_CSTCN_CTP cannot be deployed because CSTCN_CTP_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.ContactType', N'CTP_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CTP_id';

        ;THROW 50668,
            N'Foreign key FK_CSTCN_CTP cannot be deployed because referenced column reference.ContactType.CTP_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CSTCN_CTP_id -> tinyint NOT NULL
            CTP_id       -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'reference.ContactType')

        WHERE parent_column.object_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND parent_column.name =
                N'CSTCN_CTP_id'

        AND referenced_column.name =
                N'CTP_id'

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

        PRINT N'        [X] Foreign key column mismatch    : CSTCN_CTP_id -> CTP_id';

        ;THROW 50669,
            N'Foreign key FK_CSTCN_CTP cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_CSTCN_CTP';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @CSTCN_CTP_FK_actual_name =
            fk.name,

        @CSTCN_CTP_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @CSTCN_CTP_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @CSTCN_CTP_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CSTCN_CTP_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CSTCN_CTP_FK_actual_is_disabled =
            fk.is_disabled,

        @CSTCN_CTP_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CSTCN_CTP_FK_actual_parent_columns =
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

        @CSTCN_CTP_FK_actual_referenced_columns =
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
            OBJECT_ID(N'customer.CustomerContact')

    AND fk.name =
            @CSTCN_CTP_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @CSTCN_CTP_FK_actual_name IS NOT NULL
    BEGIN

        IF @CSTCN_CTP_FK_actual_parent_table =
                N'[customer].[CustomerContact]'

        AND @CSTCN_CTP_FK_actual_parent_columns =
                N'CSTCN_CTP_id'

        AND @CSTCN_CTP_FK_actual_referenced_table =
                N'[reference].[ContactType]'

        AND @CSTCN_CTP_FK_actual_referenced_columns =
                N'CTP_id'

        AND @CSTCN_CTP_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CSTCN_CTP_FK_actual_update_action =
                N'NO_ACTION'

        AND @CSTCN_CTP_FK_actual_is_disabled = 0

        AND @CSTCN_CTP_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CSTCN_CTP';
            PRINT N'            Column                          : CSTCN_CTP_id';
            PRINT N'            References                      : reference.ContactType.CTP_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CSTCN_CTP';

            PRINT N'            Expected Table                  : customer.CustomerContact';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @CSTCN_CTP_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : CSTCN_CTP_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CSTCN_CTP_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : reference.ContactType.CTP_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @CSTCN_CTP_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CSTCN_CTP_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @CSTCN_CTP_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @CSTCN_CTP_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CSTCN_CTP_FK_actual_is_disabled
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
                        @CSTCN_CTP_FK_actual_is_not_trusted
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

            @CSTCN_CTP_FK_equivalent_name =
                fk.name,

            @CSTCN_CTP_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CSTCN_CTP_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CSTCN_CTP_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CSTCN_CTP_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerContact')

        AND fk.referenced_object_id =
                OBJECT_ID(N'reference.ContactType')

        AND fk.name <>
                @CSTCN_CTP_FK_expected_name

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
                    N'CSTCN_CTP_id'

            AND rc.name =
                    N'CTP_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @CSTCN_CTP_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_CSTCN_CTP';

            PRINT N'            Actual Name                    : '
                + @CSTCN_CTP_FK_equivalent_name;

            PRINT N'            Column                         : CSTCN_CTP_id';

            PRINT N'            References                     : reference.ContactType.CTP_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @CSTCN_CTP_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @CSTCN_CTP_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CSTCN_CTP_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @CSTCN_CTP_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'customer.FK_CSTCN_CTP', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CSTCN_CTP_FK_conflict_parent =
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
                            N'customer.FK_CSTCN_CTP',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_CSTCN_CTP';
                PRINT N'            Expected Table                  : customer.CustomerContact';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @CSTCN_CTP_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50670,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE customer.CustomerContact
                WITH CHECK
                ADD CONSTRAINT FK_CSTCN_CTP
                FOREIGN KEY
                (
                    CSTCN_CTP_id
                )
                REFERENCES reference.ContactType
                (
                    CTP_id
                );


            ALTER TABLE customer.CustomerContact
                CHECK CONSTRAINT FK_CSTCN_CTP;


            PRINT N'        [+] Foreign key constraint added    : FK_CSTCN_CTP';
            PRINT N'            Column                          : CSTCN_CTP_id';
            PRINT N'            References                      : reference.ContactType.CTP_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';