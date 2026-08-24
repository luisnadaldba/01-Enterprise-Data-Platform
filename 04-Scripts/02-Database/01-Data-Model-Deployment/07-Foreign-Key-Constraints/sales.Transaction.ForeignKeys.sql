    PRINT N'';
    PRINT N'    ● sales.Transaction';
    PRINT N'';


    /*==========================================================================
        FOREIGN KEY: FK_TRN_CST
    ==========================================================================*/

    DECLARE @TRN_CST_FK_expected_name                sysname;
    DECLARE @TRN_CST_FK_actual_name                  sysname;

    DECLARE @TRN_CST_FK_actual_parent_table          nvarchar(517);
    DECLARE @TRN_CST_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @TRN_CST_FK_actual_referenced_table      nvarchar(517);
    DECLARE @TRN_CST_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @TRN_CST_FK_actual_delete_action         nvarchar(60);
    DECLARE @TRN_CST_FK_actual_update_action         nvarchar(60);

    DECLARE @TRN_CST_FK_actual_is_disabled           bit;
    DECLARE @TRN_CST_FK_actual_is_not_trusted        bit;

    DECLARE @TRN_CST_FK_equivalent_name              sysname;
    DECLARE @TRN_CST_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @TRN_CST_FK_equivalent_update_action     nvarchar(60);
    DECLARE @TRN_CST_FK_equivalent_is_disabled       bit;
    DECLARE @TRN_CST_FK_equivalent_is_not_trusted    bit;

    DECLARE @TRN_CST_FK_conflict_parent              nvarchar(517);


    SET @TRN_CST_FK_expected_name = N'FK_TRN_CST';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.Transaction';

        ;THROW 50410,
            N'Foreign key FK_TRN_CST cannot be deployed because sales.Transaction does not exist.',
            1;

    END;


    IF OBJECT_ID(N'customer.Customer', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.Customer';

        ;THROW 50411,
            N'Foreign key FK_TRN_CST cannot be deployed because customer.Customer does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_CST_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : TRN_CST_id';

        ;THROW 50412,
            N'Foreign key FK_TRN_CST cannot be deployed because TRN_CST_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.Customer', N'CST_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CST_id';

        ;THROW 50413,
            N'Foreign key FK_TRN_CST cannot be deployed because referenced column customer.Customer.CST_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            TRN_CST_id -> int NULL
            CST_id     -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'customer.Customer')

        WHERE parent_column.object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND parent_column.name =
                N'TRN_CST_id'

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

        PRINT N'        [X] Foreign key column mismatch    : TRN_CST_id -> CST_id';

        ;THROW 50414,
            N'Foreign key FK_TRN_CST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_TRN_CST';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @TRN_CST_FK_actual_name =
            fk.name,

        @TRN_CST_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @TRN_CST_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @TRN_CST_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @TRN_CST_FK_actual_update_action =
            fk.update_referential_action_desc,

        @TRN_CST_FK_actual_is_disabled =
            fk.is_disabled,

        @TRN_CST_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @TRN_CST_FK_actual_parent_columns =
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

        @TRN_CST_FK_actual_referenced_columns =
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
            OBJECT_ID(N'sales.[Transaction]')

    AND fk.name =
            @TRN_CST_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @TRN_CST_FK_actual_name IS NOT NULL
    BEGIN

        IF @TRN_CST_FK_actual_parent_table =
                N'[sales].[Transaction]'

        AND @TRN_CST_FK_actual_parent_columns =
                N'TRN_CST_id'

        AND @TRN_CST_FK_actual_referenced_table =
                N'[customer].[Customer]'

        AND @TRN_CST_FK_actual_referenced_columns =
                N'CST_id'

        AND @TRN_CST_FK_actual_delete_action =
                N'NO_ACTION'

        AND @TRN_CST_FK_actual_update_action =
                N'NO_ACTION'

        AND @TRN_CST_FK_actual_is_disabled = 0

        AND @TRN_CST_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_TRN_CST';
            PRINT N'            Column                          : TRN_CST_id';
            PRINT N'            References                      : customer.Customer.CST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_TRN_CST';

            PRINT N'            Expected Table                  : sales.Transaction';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @TRN_CST_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : TRN_CST_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRN_CST_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : customer.Customer.CST_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @TRN_CST_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRN_CST_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @TRN_CST_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @TRN_CST_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_CST_FK_actual_is_disabled
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
                        @TRN_CST_FK_actual_is_not_trusted
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

            @TRN_CST_FK_equivalent_name =
                fk.name,

            @TRN_CST_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @TRN_CST_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @TRN_CST_FK_equivalent_is_disabled =
                fk.is_disabled,

            @TRN_CST_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.name <>
                @TRN_CST_FK_expected_name

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
                    N'TRN_CST_id'

            AND rc.name =
                    N'CST_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @TRN_CST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_TRN_CST';

            PRINT N'            Actual Name                    : '
                + @TRN_CST_FK_equivalent_name;

            PRINT N'            Column                         : TRN_CST_id';

            PRINT N'            References                     : customer.Customer.CST_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @TRN_CST_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @TRN_CST_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_CST_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_CST_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'sales.FK_TRN_CST', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @TRN_CST_FK_conflict_parent =
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
                            N'sales.FK_TRN_CST',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_TRN_CST';
                PRINT N'            Expected Table                  : sales.Transaction';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @TRN_CST_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50415,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE sales.[Transaction]
                WITH CHECK
                ADD CONSTRAINT FK_TRN_CST
                FOREIGN KEY
                (
                    TRN_CST_id
                )
                REFERENCES customer.Customer
                (
                    CST_id
                );


            ALTER TABLE sales.[Transaction]
                CHECK CONSTRAINT FK_TRN_CST;


            PRINT N'        [+] Foreign key constraint added    : FK_TRN_CST';
            PRINT N'            Column                          : TRN_CST_id';
            PRINT N'            References                      : customer.Customer.CST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_TRN_TRNST
    ==============================================================================*/

    DECLARE @TRN_TRNST_FK_expected_name                sysname;
    DECLARE @TRN_TRNST_FK_actual_name                  sysname;

    DECLARE @TRN_TRNST_FK_actual_parent_table          nvarchar(517);
    DECLARE @TRN_TRNST_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @TRN_TRNST_FK_actual_referenced_table      nvarchar(517);
    DECLARE @TRN_TRNST_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @TRN_TRNST_FK_actual_delete_action         nvarchar(60);
    DECLARE @TRN_TRNST_FK_actual_update_action         nvarchar(60);

    DECLARE @TRN_TRNST_FK_actual_is_disabled           bit;
    DECLARE @TRN_TRNST_FK_actual_is_not_trusted        bit;

    DECLARE @TRN_TRNST_FK_equivalent_name              sysname;
    DECLARE @TRN_TRNST_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @TRN_TRNST_FK_equivalent_update_action     nvarchar(60);
    DECLARE @TRN_TRNST_FK_equivalent_is_disabled       bit;
    DECLARE @TRN_TRNST_FK_equivalent_is_not_trusted    bit;

    DECLARE @TRN_TRNST_FK_conflict_parent              nvarchar(517);


    SET @TRN_TRNST_FK_expected_name = N'FK_TRN_TRNST';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'sales.TransactionStatus', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.TransactionStatus';

        ;THROW 50416,
            N'Foreign key FK_TRN_TRNST cannot be deployed because sales.TransactionStatus does not exist.',
            1;

    END;


    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.Transaction';

        ;THROW 50417,
            N'Foreign key FK_TRN_TRNST cannot be deployed because sales.Transaction does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_TRNST_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : TRN_TRNST_id';

        ;THROW 50418,
            N'Foreign key FK_TRN_TRNST cannot be deployed because TRN_TRNST_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionStatus', N'TRNST_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRNST_id';

        ;THROW 50419,
            N'Foreign key FK_TRN_TRNST cannot be deployed because referenced column sales.TransactionStatus.TRNST_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            TRN_TRNST_id -> tinyint NOT NULL
            TRNST_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.TransactionStatus')

        WHERE parent_column.object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND parent_column.name =
                N'TRN_TRNST_id'

        AND referenced_column.name =
                N'TRNST_id'

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

        PRINT N'        [X] Foreign key column mismatch    : TRN_TRNST_id -> TRNST_id';

        ;THROW 50420,
            N'Foreign key FK_TRN_TRNST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_TRN_TRNST';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @TRN_TRNST_FK_actual_name =
            fk.name,

        @TRN_TRNST_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @TRN_TRNST_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @TRN_TRNST_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @TRN_TRNST_FK_actual_update_action =
            fk.update_referential_action_desc,

        @TRN_TRNST_FK_actual_is_disabled =
            fk.is_disabled,

        @TRN_TRNST_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @TRN_TRNST_FK_actual_parent_columns =
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

        @TRN_TRNST_FK_actual_referenced_columns =
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
            OBJECT_ID(N'sales.[Transaction]')

    AND fk.name =
            @TRN_TRNST_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @TRN_TRNST_FK_actual_name IS NOT NULL
    BEGIN

        IF @TRN_TRNST_FK_actual_parent_table =
                N'[sales].[Transaction]'

        AND @TRN_TRNST_FK_actual_parent_columns =
                N'TRN_TRNST_id'

        AND @TRN_TRNST_FK_actual_referenced_table =
                N'[sales].[TransactionStatus]'

        AND @TRN_TRNST_FK_actual_referenced_columns =
                N'TRNST_id'

        AND @TRN_TRNST_FK_actual_delete_action =
                N'NO_ACTION'

        AND @TRN_TRNST_FK_actual_update_action =
                N'NO_ACTION'

        AND @TRN_TRNST_FK_actual_is_disabled = 0

        AND @TRN_TRNST_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_TRN_TRNST';
            PRINT N'            Column                          : TRN_TRNST_id';
            PRINT N'            References                      : sales.TransactionStatus.TRNST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_TRN_TRNST';

            PRINT N'            Expected Table                  : sales.Transaction';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @TRN_TRNST_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : TRN_TRNST_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRN_TRNST_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : sales.TransactionStatus.TRNST_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @TRN_TRNST_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRN_TRNST_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @TRN_TRNST_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @TRN_TRNST_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_TRNST_FK_actual_is_disabled
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
                        @TRN_TRNST_FK_actual_is_not_trusted
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

            @TRN_TRNST_FK_equivalent_name =
                fk.name,

            @TRN_TRNST_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @TRN_TRNST_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @TRN_TRNST_FK_equivalent_is_disabled =
                fk.is_disabled,

            @TRN_TRNST_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND fk.name <>
                @TRN_TRNST_FK_expected_name

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
                    N'TRN_TRNST_id'

            AND rc.name =
                    N'TRNST_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @TRN_TRNST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_TRN_TRNST';

            PRINT N'            Actual Name                    : '
                + @TRN_TRNST_FK_equivalent_name;

            PRINT N'            Column                         : TRN_TRNST_id';

            PRINT N'            References                     : sales.TransactionStatus.TRNST_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @TRN_TRNST_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @TRN_TRNST_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_TRNST_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_TRNST_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'sales.FK_TRN_TRNST', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @TRN_TRNST_FK_conflict_parent =
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
                            N'sales.FK_TRN_TRNST',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_TRN_TRNST';
                PRINT N'            Expected Table                  : sales.Transaction';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @TRN_TRNST_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50421,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE sales.[Transaction]
                WITH CHECK
                ADD CONSTRAINT FK_TRN_TRNST
                FOREIGN KEY
                (
                    TRN_TRNST_id
                )
                REFERENCES sales.TransactionStatus
                (
                    TRNST_id
                );


            ALTER TABLE sales.[Transaction]
                CHECK CONSTRAINT FK_TRN_TRNST;


            PRINT N'        [+] Foreign key constraint added    : FK_TRN_TRNST';
            PRINT N'            Column                          : TRN_TRNST_id';
            PRINT N'            References                      : sales.TransactionStatus.TRNST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_TRN_TRNCH
    ==============================================================================*/

    DECLARE @TRN_TRNCH_FK_expected_name                sysname;
    DECLARE @TRN_TRNCH_FK_actual_name                  sysname;

    DECLARE @TRN_TRNCH_FK_actual_parent_table          nvarchar(517);
    DECLARE @TRN_TRNCH_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @TRN_TRNCH_FK_actual_referenced_table      nvarchar(517);
    DECLARE @TRN_TRNCH_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @TRN_TRNCH_FK_actual_delete_action         nvarchar(60);
    DECLARE @TRN_TRNCH_FK_actual_update_action         nvarchar(60);

    DECLARE @TRN_TRNCH_FK_actual_is_disabled           bit;
    DECLARE @TRN_TRNCH_FK_actual_is_not_trusted        bit;

    DECLARE @TRN_TRNCH_FK_equivalent_name              sysname;
    DECLARE @TRN_TRNCH_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @TRN_TRNCH_FK_equivalent_update_action     nvarchar(60);
    DECLARE @TRN_TRNCH_FK_equivalent_is_disabled       bit;
    DECLARE @TRN_TRNCH_FK_equivalent_is_not_trusted    bit;

    DECLARE @TRN_TRNCH_FK_conflict_parent              nvarchar(517);


    SET @TRN_TRNCH_FK_expected_name = N'FK_TRN_TRNCH';


    /*==========================================================================
        DEPENDENCY VALIDATION
    ==========================================================================*/

    IF OBJECT_ID(N'sales.TransactionChannel', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.TransactionChannel';

        ;THROW 50422,
            N'Foreign key FK_TRN_TRNCH cannot be deployed because sales.TransactionChannel does not exist.',
            1;

    END;


    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.Transaction';

        ;THROW 50423,
            N'Foreign key FK_TRN_TRNCH cannot be deployed because sales.Transaction does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_TRNCH_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : TRN_TRNCH_id';

        ;THROW 50424,
            N'Foreign key FK_TRN_TRNCH cannot be deployed because TRN_TRNCH_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.TransactionChannel', N'TRNCH_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRNCH_id';

        ;THROW 50425,
            N'Foreign key FK_TRN_TRNCH cannot be deployed because referenced column sales.TransactionChannel.TRNCH_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            TRN_TRNCH_id -> tinyint NOT NULL
            TRNCH_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.TransactionChannel')

        WHERE parent_column.object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND parent_column.name =
                N'TRN_TRNCH_id'

        AND referenced_column.name =
                N'TRNCH_id'

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

        PRINT N'        [X] Foreign key column mismatch    : TRN_TRNCH_id -> TRNCH_id';

        ;THROW 50426,
            N'Foreign key FK_TRN_TRNCH cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_TRN_TRNCH';


    /*==========================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==========================================================================*/

    SELECT
        @TRN_TRNCH_FK_actual_name =
            fk.name,

        @TRN_TRNCH_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @TRN_TRNCH_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @TRN_TRNCH_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @TRN_TRNCH_FK_actual_update_action =
            fk.update_referential_action_desc,

        @TRN_TRNCH_FK_actual_is_disabled =
            fk.is_disabled,

        @TRN_TRNCH_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @TRN_TRNCH_FK_actual_parent_columns =
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

        @TRN_TRNCH_FK_actual_referenced_columns =
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
            OBJECT_ID(N'sales.[Transaction]')

    AND fk.name =
            @TRN_TRNCH_FK_expected_name;


    /*==========================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==========================================================================*/

    IF @TRN_TRNCH_FK_actual_name IS NOT NULL
    BEGIN

        IF @TRN_TRNCH_FK_actual_parent_table =
                N'[sales].[Transaction]'

        AND @TRN_TRNCH_FK_actual_parent_columns =
                N'TRN_TRNCH_id'

        AND @TRN_TRNCH_FK_actual_referenced_table =
                N'[sales].[TransactionChannel]'

        AND @TRN_TRNCH_FK_actual_referenced_columns =
                N'TRNCH_id'

        AND @TRN_TRNCH_FK_actual_delete_action =
                N'NO_ACTION'

        AND @TRN_TRNCH_FK_actual_update_action =
                N'NO_ACTION'

        AND @TRN_TRNCH_FK_actual_is_disabled = 0

        AND @TRN_TRNCH_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_TRN_TRNCH';
            PRINT N'            Column                          : TRN_TRNCH_id';
            PRINT N'            References                      : sales.TransactionChannel.TRNCH_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_TRN_TRNCH';

            PRINT N'            Expected Table                  : sales.Transaction';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @TRN_TRNCH_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : TRN_TRNCH_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRN_TRNCH_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : sales.TransactionChannel.TRNCH_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @TRN_TRNCH_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @TRN_TRNCH_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @TRN_TRNCH_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @TRN_TRNCH_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_TRNCH_FK_actual_is_disabled
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
                        @TRN_TRNCH_FK_actual_is_not_trusted
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

            @TRN_TRNCH_FK_equivalent_name =
                fk.name,

            @TRN_TRNCH_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @TRN_TRNCH_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @TRN_TRNCH_FK_equivalent_is_disabled =
                fk.is_disabled,

            @TRN_TRNCH_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.TransactionChannel')

        AND fk.name <>
                @TRN_TRNCH_FK_expected_name

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
                    N'TRN_TRNCH_id'

            AND rc.name =
                    N'TRNCH_id'
        )

        ORDER BY fk.name;


        /*----------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        ----------------------------------------------------------------------*/

        IF @TRN_TRNCH_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_TRN_TRNCH';

            PRINT N'            Actual Name                    : '
                + @TRN_TRNCH_FK_equivalent_name;

            PRINT N'            Column                         : TRN_TRNCH_id';

            PRINT N'            References                     : sales.TransactionChannel.TRNCH_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @TRN_TRNCH_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @TRN_TRNCH_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_TRNCH_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @TRN_TRNCH_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'sales.FK_TRN_TRNCH', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @TRN_TRNCH_FK_conflict_parent =
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
                            N'sales.FK_TRN_TRNCH',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_TRN_TRNCH';
                PRINT N'            Expected Table                  : sales.Transaction';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @TRN_TRNCH_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50427,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==================================================================
                CREATE FOREIGN KEY
            ==================================================================*/

            ALTER TABLE sales.[Transaction]
                WITH CHECK
                ADD CONSTRAINT FK_TRN_TRNCH
                FOREIGN KEY
                (
                    TRN_TRNCH_id
                )
                REFERENCES sales.TransactionChannel
                (
                    TRNCH_id
                );


            ALTER TABLE sales.[Transaction]
                CHECK CONSTRAINT FK_TRN_TRNCH;


            PRINT N'        [+] Foreign key constraint added    : FK_TRN_TRNCH';
            PRINT N'            Column                          : TRN_TRNCH_id';
            PRINT N'            References                      : sales.TransactionChannel.TRNCH_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';