    PRINT N'';
    PRINT N'    ● shipping.Shipment';
    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_SHP_TRN
    ==============================================================================*/

    DECLARE @SHP_TRN_FK_expected_name                sysname;
    DECLARE @SHP_TRN_FK_actual_name                  sysname;

    DECLARE @SHP_TRN_FK_actual_parent_table          nvarchar(517);
    DECLARE @SHP_TRN_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @SHP_TRN_FK_actual_referenced_table      nvarchar(517);
    DECLARE @SHP_TRN_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @SHP_TRN_FK_actual_delete_action         nvarchar(60);
    DECLARE @SHP_TRN_FK_actual_update_action         nvarchar(60);

    DECLARE @SHP_TRN_FK_actual_is_disabled           bit;
    DECLARE @SHP_TRN_FK_actual_is_not_trusted        bit;

    DECLARE @SHP_TRN_FK_equivalent_name              sysname;
    DECLARE @SHP_TRN_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @SHP_TRN_FK_equivalent_update_action     nvarchar(60);
    DECLARE @SHP_TRN_FK_equivalent_is_disabled       bit;
    DECLARE @SHP_TRN_FK_equivalent_is_not_trusted    bit;

    DECLARE @SHP_TRN_FK_conflict_parent              nvarchar(517);


    SET @SHP_TRN_FK_expected_name = N'FK_SHP_TRN';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'shipping.Shipment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : shipping.Shipment';

        ;THROW 51240,
            N'Foreign key FK_SHP_TRN cannot be deployed because shipping.Shipment does not exist.',
            1;

    END;


    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : sales.Transaction';

        ;THROW 51241,
            N'Foreign key FK_SHP_TRN cannot be deployed because sales.Transaction does not exist.',
            1;

    END;


    IF COL_LENGTH(N'shipping.Shipment', N'SHP_TRN_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : SHP_TRN_id';

        ;THROW 51242,
            N'Foreign key FK_SHP_TRN cannot be deployed because SHP_TRN_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'shipping.Shipment', N'SHP_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : SHP_transaction_at';

        ;THROW 51243,
            N'Foreign key FK_SHP_TRN cannot be deployed because SHP_transaction_at does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRN_id';

        ;THROW 51244,
            N'Foreign key FK_SHP_TRN cannot be deployed because referenced column sales.Transaction.TRN_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : TRN_transaction_at';

        ;THROW 51245,
            N'Foreign key FK_SHP_TRN cannot be deployed because referenced column sales.Transaction.TRN_transaction_at does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            SHP_TRN_id         -> bigint NOT NULL
            TRN_id             -> bigint NOT NULL

            SHP_transaction_at -> datetime2(0) NOT NULL
            TRN_transaction_at -> datetime2(0) NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.[Transaction]')

        WHERE parent_column.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND parent_column.name =
                N'SHP_TRN_id'

        AND referenced_column.name =
                N'TRN_id'

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

        PRINT N'        [X] Foreign key column mismatch    : SHP_TRN_id -> TRN_id';

        ;THROW 51246,
            N'Foreign key FK_SHP_TRN cannot be deployed because participating columns are incompatible.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'sales.[Transaction]')

        WHERE parent_column.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND parent_column.name =
                N'SHP_transaction_at'

        AND referenced_column.name =
                N'TRN_transaction_at'

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

        PRINT N'        [X] Foreign key column mismatch    : SHP_transaction_at -> TRN_transaction_at';

        ;THROW 51247,
            N'Foreign key FK_SHP_TRN cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_SHP_TRN';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @SHP_TRN_FK_actual_name =
            fk.name,

        @SHP_TRN_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @SHP_TRN_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @SHP_TRN_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @SHP_TRN_FK_actual_update_action =
            fk.update_referential_action_desc,

        @SHP_TRN_FK_actual_is_disabled =
            fk.is_disabled,

        @SHP_TRN_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @SHP_TRN_FK_actual_parent_columns =
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

        @SHP_TRN_FK_actual_referenced_columns =
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
            OBJECT_ID(N'shipping.Shipment')

    AND fk.name =
            @SHP_TRN_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @SHP_TRN_FK_actual_name IS NOT NULL
    BEGIN

        IF @SHP_TRN_FK_actual_parent_table =
                N'[shipping].[Shipment]'

        AND @SHP_TRN_FK_actual_parent_columns =
                N'SHP_TRN_id|SHP_transaction_at'

        AND @SHP_TRN_FK_actual_referenced_table =
                N'[sales].[Transaction]'

        AND @SHP_TRN_FK_actual_referenced_columns =
                N'TRN_id|TRN_transaction_at'

        AND @SHP_TRN_FK_actual_delete_action =
                N'NO_ACTION'

        AND @SHP_TRN_FK_actual_update_action =
                N'NO_ACTION'

        AND @SHP_TRN_FK_actual_is_disabled = 0

        AND @SHP_TRN_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_SHP_TRN';
            PRINT N'            Columns                         : SHP_TRN_id, SHP_transaction_at';
            PRINT N'            References                      : sales.Transaction(TRN_id, TRN_transaction_at)';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_SHP_TRN';

            PRINT N'            Expected Table                  : shipping.Shipment';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @SHP_TRN_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Columns                : SHP_TRN_id, SHP_transaction_at';
            PRINT N'            Actual Columns                  : '
                + COALESCE
                (
                    REPLACE
                    (
                        @SHP_TRN_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : sales.Transaction(TRN_id, TRN_transaction_at)';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @SHP_TRN_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Columns       : '
                + COALESCE
                (
                    REPLACE
                    (
                        @SHP_TRN_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @SHP_TRN_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @SHP_TRN_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_TRN_FK_actual_is_disabled
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
                        @SHP_TRN_FK_actual_is_not_trusted
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

            @SHP_TRN_FK_equivalent_name =
                fk.name,

            @SHP_TRN_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @SHP_TRN_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @SHP_TRN_FK_equivalent_is_disabled =
                fk.is_disabled,

            @SHP_TRN_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND fk.name <>
                @SHP_TRN_FK_expected_name

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
                    N'SHP_TRN_id'

            AND rc.name =
                    N'TRN_id'
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
                    N'SHP_transaction_at'

            AND rc.name =
                    N'TRN_transaction_at'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @SHP_TRN_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_SHP_TRN';

            PRINT N'            Actual Name                    : '
                + @SHP_TRN_FK_equivalent_name;

            PRINT N'            Columns                         : SHP_TRN_id, SHP_transaction_at';

            PRINT N'            References                     : sales.Transaction(TRN_id, TRN_transaction_at)';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @SHP_TRN_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @SHP_TRN_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_TRN_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_TRN_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'shipping.FK_SHP_TRN', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @SHP_TRN_FK_conflict_parent =
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
                            N'shipping.FK_SHP_TRN',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_SHP_TRN';
                PRINT N'            Expected Table                  : shipping.Shipment';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @SHP_TRN_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 51248,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE shipping.Shipment
                WITH CHECK
                ADD CONSTRAINT FK_SHP_TRN
                FOREIGN KEY
                (
                    SHP_TRN_id,
                    SHP_transaction_at
                )
                REFERENCES sales.[Transaction]
                (
                    TRN_id,
                    TRN_transaction_at
                );


            ALTER TABLE shipping.Shipment
                CHECK CONSTRAINT FK_SHP_TRN;


            PRINT N'        [+] Foreign key constraint added    : FK_SHP_TRN';
            PRINT N'            Columns                         : SHP_TRN_id, SHP_transaction_at';
            PRINT N'            References                      : sales.Transaction(TRN_id, TRN_transaction_at)';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_SHP_CSTAD
    ==============================================================================*/

    DECLARE @SHP_CSTAD_FK_expected_name                sysname;
    DECLARE @SHP_CSTAD_FK_actual_name                  sysname;

    DECLARE @SHP_CSTAD_FK_actual_parent_table          nvarchar(517);
    DECLARE @SHP_CSTAD_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @SHP_CSTAD_FK_actual_referenced_table      nvarchar(517);
    DECLARE @SHP_CSTAD_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @SHP_CSTAD_FK_actual_delete_action         nvarchar(60);
    DECLARE @SHP_CSTAD_FK_actual_update_action         nvarchar(60);

    DECLARE @SHP_CSTAD_FK_actual_is_disabled           bit;
    DECLARE @SHP_CSTAD_FK_actual_is_not_trusted        bit;

    DECLARE @SHP_CSTAD_FK_equivalent_name              sysname;
    DECLARE @SHP_CSTAD_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @SHP_CSTAD_FK_equivalent_update_action     nvarchar(60);
    DECLARE @SHP_CSTAD_FK_equivalent_is_disabled       bit;
    DECLARE @SHP_CSTAD_FK_equivalent_is_not_trusted    bit;

    DECLARE @SHP_CSTAD_FK_conflict_parent              nvarchar(517);


    SET @SHP_CSTAD_FK_expected_name = N'FK_SHP_CSTAD';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'shipping.Shipment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : shipping.Shipment';

        ;THROW 51249,
            N'Foreign key FK_SHP_CSTAD cannot be deployed because shipping.Shipment does not exist.',
            1;

    END;


    IF OBJECT_ID(N'customer.CustomerAddress', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.CustomerAddress';

        ;THROW 51250,
            N'Foreign key FK_SHP_CSTAD cannot be deployed because customer.CustomerAddress does not exist.',
            1;

    END;


    IF COL_LENGTH(N'shipping.Shipment', N'SHP_CSTAD_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : SHP_CSTAD_id';

        ;THROW 51251,
            N'Foreign key FK_SHP_CSTAD cannot be deployed because SHP_CSTAD_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerAddress', N'CSTAD_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CSTAD_id';

        ;THROW 51252,
            N'Foreign key FK_SHP_CSTAD cannot be deployed because referenced column customer.CustomerAddress.CSTAD_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            SHP_CSTAD_id -> int NOT NULL
            CSTAD_id     -> int NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'customer.CustomerAddress')

        WHERE parent_column.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND parent_column.name =
                N'SHP_CSTAD_id'

        AND referenced_column.name =
                N'CSTAD_id'

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

        PRINT N'        [X] Foreign key column mismatch    : SHP_CSTAD_id -> CSTAD_id';

        ;THROW 51253,
            N'Foreign key FK_SHP_CSTAD cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_SHP_CSTAD';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @SHP_CSTAD_FK_actual_name =
            fk.name,

        @SHP_CSTAD_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @SHP_CSTAD_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @SHP_CSTAD_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @SHP_CSTAD_FK_actual_update_action =
            fk.update_referential_action_desc,

        @SHP_CSTAD_FK_actual_is_disabled =
            fk.is_disabled,

        @SHP_CSTAD_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @SHP_CSTAD_FK_actual_parent_columns =
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

        @SHP_CSTAD_FK_actual_referenced_columns =
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
            OBJECT_ID(N'shipping.Shipment')

    AND fk.name =
            @SHP_CSTAD_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @SHP_CSTAD_FK_actual_name IS NOT NULL
    BEGIN

        IF @SHP_CSTAD_FK_actual_parent_table =
                N'[shipping].[Shipment]'

        AND @SHP_CSTAD_FK_actual_parent_columns =
                N'SHP_CSTAD_id'

        AND @SHP_CSTAD_FK_actual_referenced_table =
                N'[customer].[CustomerAddress]'

        AND @SHP_CSTAD_FK_actual_referenced_columns =
                N'CSTAD_id'

        AND @SHP_CSTAD_FK_actual_delete_action =
                N'NO_ACTION'

        AND @SHP_CSTAD_FK_actual_update_action =
                N'NO_ACTION'

        AND @SHP_CSTAD_FK_actual_is_disabled = 0

        AND @SHP_CSTAD_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_SHP_CSTAD';
            PRINT N'            Column                          : SHP_CSTAD_id';
            PRINT N'            References                      : customer.CustomerAddress.CSTAD_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_SHP_CSTAD';

            PRINT N'            Expected Table                  : shipping.Shipment';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @SHP_CSTAD_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : SHP_CSTAD_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @SHP_CSTAD_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : customer.CustomerAddress.CSTAD_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @SHP_CSTAD_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @SHP_CSTAD_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @SHP_CSTAD_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @SHP_CSTAD_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_CSTAD_FK_actual_is_disabled
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
                        @SHP_CSTAD_FK_actual_is_not_trusted
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

            @SHP_CSTAD_FK_equivalent_name =
                fk.name,

            @SHP_CSTAD_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @SHP_CSTAD_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @SHP_CSTAD_FK_equivalent_is_disabled =
                fk.is_disabled,

            @SHP_CSTAD_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.CustomerAddress')

        AND fk.name <>
                @SHP_CSTAD_FK_expected_name

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
                    N'SHP_CSTAD_id'

            AND rc.name =
                    N'CSTAD_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @SHP_CSTAD_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_SHP_CSTAD';

            PRINT N'            Actual Name                    : '
                + @SHP_CSTAD_FK_equivalent_name;

            PRINT N'            Column                         : SHP_CSTAD_id';

            PRINT N'            References                     : customer.CustomerAddress.CSTAD_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @SHP_CSTAD_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @SHP_CSTAD_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_CSTAD_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_CSTAD_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'shipping.FK_SHP_CSTAD', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @SHP_CSTAD_FK_conflict_parent =
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
                            N'shipping.FK_SHP_CSTAD',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_SHP_CSTAD';
                PRINT N'            Expected Table                  : shipping.Shipment';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @SHP_CSTAD_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 51254,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE shipping.Shipment
                WITH CHECK
                ADD CONSTRAINT FK_SHP_CSTAD
                FOREIGN KEY
                (
                    SHP_CSTAD_id
                )
                REFERENCES customer.CustomerAddress
                (
                    CSTAD_id
                );


            ALTER TABLE shipping.Shipment
                CHECK CONSTRAINT FK_SHP_CSTAD;


            PRINT N'        [+] Foreign key constraint added    : FK_SHP_CSTAD';
            PRINT N'            Column                          : SHP_CSTAD_id';
            PRINT N'            References                      : customer.CustomerAddress.CSTAD_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_SHP_SHPMT
    ==============================================================================*/

    DECLARE @SHP_SHPMT_FK_expected_name                sysname;
    DECLARE @SHP_SHPMT_FK_actual_name                  sysname;

    DECLARE @SHP_SHPMT_FK_actual_parent_table          nvarchar(517);
    DECLARE @SHP_SHPMT_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @SHP_SHPMT_FK_actual_referenced_table      nvarchar(517);
    DECLARE @SHP_SHPMT_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @SHP_SHPMT_FK_actual_delete_action         nvarchar(60);
    DECLARE @SHP_SHPMT_FK_actual_update_action         nvarchar(60);

    DECLARE @SHP_SHPMT_FK_actual_is_disabled           bit;
    DECLARE @SHP_SHPMT_FK_actual_is_not_trusted        bit;

    DECLARE @SHP_SHPMT_FK_equivalent_name              sysname;
    DECLARE @SHP_SHPMT_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @SHP_SHPMT_FK_equivalent_update_action     nvarchar(60);
    DECLARE @SHP_SHPMT_FK_equivalent_is_disabled       bit;
    DECLARE @SHP_SHPMT_FK_equivalent_is_not_trusted    bit;

    DECLARE @SHP_SHPMT_FK_conflict_parent              nvarchar(517);


    SET @SHP_SHPMT_FK_expected_name = N'FK_SHP_SHPMT';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'shipping.Shipment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : shipping.Shipment';

        ;THROW 51255,
            N'Foreign key FK_SHP_SHPMT cannot be deployed because shipping.Shipment does not exist.',
            1;

    END;


    IF OBJECT_ID(N'shipping.ShipmentMethod', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : shipping.ShipmentMethod';

        ;THROW 51256,
            N'Foreign key FK_SHP_SHPMT cannot be deployed because shipping.ShipmentMethod does not exist.',
            1;

    END;


    IF COL_LENGTH(N'shipping.Shipment', N'SHP_SHPMT_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : SHP_SHPMT_id';

        ;THROW 51257,
            N'Foreign key FK_SHP_SHPMT cannot be deployed because SHP_SHPMT_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'shipping.ShipmentMethod', N'SHPMT_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : SHPMT_id';

        ;THROW 51258,
            N'Foreign key FK_SHP_SHPMT cannot be deployed because referenced column shipping.ShipmentMethod.SHPMT_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            SHP_SHPMT_id -> tinyint NOT NULL
            SHPMT_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'shipping.ShipmentMethod')

        WHERE parent_column.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND parent_column.name =
                N'SHP_SHPMT_id'

        AND referenced_column.name =
                N'SHPMT_id'

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

        PRINT N'        [X] Foreign key column mismatch    : SHP_SHPMT_id -> SHPMT_id';

        ;THROW 51259,
            N'Foreign key FK_SHP_SHPMT cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_SHP_SHPMT';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @SHP_SHPMT_FK_actual_name =
            fk.name,

        @SHP_SHPMT_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @SHP_SHPMT_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @SHP_SHPMT_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @SHP_SHPMT_FK_actual_update_action =
            fk.update_referential_action_desc,

        @SHP_SHPMT_FK_actual_is_disabled =
            fk.is_disabled,

        @SHP_SHPMT_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @SHP_SHPMT_FK_actual_parent_columns =
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

        @SHP_SHPMT_FK_actual_referenced_columns =
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
            OBJECT_ID(N'shipping.Shipment')

    AND fk.name =
            @SHP_SHPMT_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @SHP_SHPMT_FK_actual_name IS NOT NULL
    BEGIN

        IF @SHP_SHPMT_FK_actual_parent_table =
                N'[shipping].[Shipment]'

        AND @SHP_SHPMT_FK_actual_parent_columns =
                N'SHP_SHPMT_id'

        AND @SHP_SHPMT_FK_actual_referenced_table =
                N'[shipping].[ShipmentMethod]'

        AND @SHP_SHPMT_FK_actual_referenced_columns =
                N'SHPMT_id'

        AND @SHP_SHPMT_FK_actual_delete_action =
                N'NO_ACTION'

        AND @SHP_SHPMT_FK_actual_update_action =
                N'NO_ACTION'

        AND @SHP_SHPMT_FK_actual_is_disabled = 0

        AND @SHP_SHPMT_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_SHP_SHPMT';
            PRINT N'            Column                          : SHP_SHPMT_id';
            PRINT N'            References                      : shipping.ShipmentMethod.SHPMT_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_SHP_SHPMT';

            PRINT N'            Expected Table                  : shipping.Shipment';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @SHP_SHPMT_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : SHP_SHPMT_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @SHP_SHPMT_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : shipping.ShipmentMethod.SHPMT_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @SHP_SHPMT_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @SHP_SHPMT_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @SHP_SHPMT_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @SHP_SHPMT_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_SHPMT_FK_actual_is_disabled
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
                        @SHP_SHPMT_FK_actual_is_not_trusted
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

            @SHP_SHPMT_FK_equivalent_name =
                fk.name,

            @SHP_SHPMT_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @SHP_SHPMT_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @SHP_SHPMT_FK_equivalent_is_disabled =
                fk.is_disabled,

            @SHP_SHPMT_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'shipping.ShipmentMethod')

        AND fk.name <>
                @SHP_SHPMT_FK_expected_name

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
                    N'SHP_SHPMT_id'

            AND rc.name =
                    N'SHPMT_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @SHP_SHPMT_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_SHP_SHPMT';

            PRINT N'            Actual Name                    : '
                + @SHP_SHPMT_FK_equivalent_name;

            PRINT N'            Column                         : SHP_SHPMT_id';

            PRINT N'            References                     : shipping.ShipmentMethod.SHPMT_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @SHP_SHPMT_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @SHP_SHPMT_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_SHPMT_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_SHPMT_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'shipping.FK_SHP_SHPMT', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @SHP_SHPMT_FK_conflict_parent =
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
                            N'shipping.FK_SHP_SHPMT',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_SHP_SHPMT';
                PRINT N'            Expected Table                  : shipping.Shipment';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @SHP_SHPMT_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 51260,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE shipping.Shipment
                WITH CHECK
                ADD CONSTRAINT FK_SHP_SHPMT
                FOREIGN KEY
                (
                    SHP_SHPMT_id
                )
                REFERENCES shipping.ShipmentMethod
                (
                    SHPMT_id
                );


            ALTER TABLE shipping.Shipment
                CHECK CONSTRAINT FK_SHP_SHPMT;


            PRINT N'        [+] Foreign key constraint added    : FK_SHP_SHPMT';
            PRINT N'            Column                          : SHP_SHPMT_id';
            PRINT N'            References                      : shipping.ShipmentMethod.SHPMT_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_SHP_SHPST
    ==============================================================================*/

    DECLARE @SHP_SHPST_FK_expected_name                sysname;
    DECLARE @SHP_SHPST_FK_actual_name                  sysname;

    DECLARE @SHP_SHPST_FK_actual_parent_table          nvarchar(517);
    DECLARE @SHP_SHPST_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @SHP_SHPST_FK_actual_referenced_table      nvarchar(517);
    DECLARE @SHP_SHPST_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @SHP_SHPST_FK_actual_delete_action         nvarchar(60);
    DECLARE @SHP_SHPST_FK_actual_update_action         nvarchar(60);

    DECLARE @SHP_SHPST_FK_actual_is_disabled           bit;
    DECLARE @SHP_SHPST_FK_actual_is_not_trusted        bit;

    DECLARE @SHP_SHPST_FK_equivalent_name              sysname;
    DECLARE @SHP_SHPST_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @SHP_SHPST_FK_equivalent_update_action     nvarchar(60);
    DECLARE @SHP_SHPST_FK_equivalent_is_disabled       bit;
    DECLARE @SHP_SHPST_FK_equivalent_is_not_trusted    bit;

    DECLARE @SHP_SHPST_FK_conflict_parent              nvarchar(517);


    SET @SHP_SHPST_FK_expected_name = N'FK_SHP_SHPST';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'shipping.Shipment', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : shipping.Shipment';

        ;THROW 51261,
            N'Foreign key FK_SHP_SHPST cannot be deployed because shipping.Shipment does not exist.',
            1;

    END;


    IF OBJECT_ID(N'shipping.ShipmentStatus', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : shipping.ShipmentStatus';

        ;THROW 51262,
            N'Foreign key FK_SHP_SHPST cannot be deployed because shipping.ShipmentStatus does not exist.',
            1;

    END;


    IF COL_LENGTH(N'shipping.Shipment', N'SHP_SHPST_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : SHP_SHPST_id';

        ;THROW 51263,
            N'Foreign key FK_SHP_SHPST cannot be deployed because SHP_SHPST_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'shipping.ShipmentStatus', N'SHPST_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : SHPST_id';

        ;THROW 51264,
            N'Foreign key FK_SHP_SHPST cannot be deployed because referenced column shipping.ShipmentStatus.SHPST_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            SHP_SHPST_id -> tinyint NOT NULL
            SHPST_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'shipping.ShipmentStatus')

        WHERE parent_column.object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND parent_column.name =
                N'SHP_SHPST_id'

        AND referenced_column.name =
                N'SHPST_id'

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

        PRINT N'        [X] Foreign key column mismatch    : SHP_SHPST_id -> SHPST_id';

        ;THROW 51265,
            N'Foreign key FK_SHP_SHPST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_SHP_SHPST';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @SHP_SHPST_FK_actual_name =
            fk.name,

        @SHP_SHPST_FK_actual_parent_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.parent_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.parent_object_id)
            ),

        @SHP_SHPST_FK_actual_referenced_table =
            QUOTENAME
            (
                OBJECT_SCHEMA_NAME(fk.referenced_object_id)
            )
            + N'.'
            + QUOTENAME
            (
                OBJECT_NAME(fk.referenced_object_id)
            ),

        @SHP_SHPST_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @SHP_SHPST_FK_actual_update_action =
            fk.update_referential_action_desc,

        @SHP_SHPST_FK_actual_is_disabled =
            fk.is_disabled,

        @SHP_SHPST_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @SHP_SHPST_FK_actual_parent_columns =
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

        @SHP_SHPST_FK_actual_referenced_columns =
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
            OBJECT_ID(N'shipping.Shipment')

    AND fk.name =
            @SHP_SHPST_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @SHP_SHPST_FK_actual_name IS NOT NULL
    BEGIN

        IF @SHP_SHPST_FK_actual_parent_table =
                N'[shipping].[Shipment]'

        AND @SHP_SHPST_FK_actual_parent_columns =
                N'SHP_SHPST_id'

        AND @SHP_SHPST_FK_actual_referenced_table =
                N'[shipping].[ShipmentStatus]'

        AND @SHP_SHPST_FK_actual_referenced_columns =
                N'SHPST_id'

        AND @SHP_SHPST_FK_actual_delete_action =
                N'NO_ACTION'

        AND @SHP_SHPST_FK_actual_update_action =
                N'NO_ACTION'

        AND @SHP_SHPST_FK_actual_is_disabled = 0

        AND @SHP_SHPST_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_SHP_SHPST';
            PRINT N'            Column                          : SHP_SHPST_id';
            PRINT N'            References                      : shipping.ShipmentStatus.SHPST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_SHP_SHPST';

            PRINT N'            Expected Table                  : shipping.Shipment';
            PRINT N'            Actual Table                    : '
                + COALESCE
                (
                    @SHP_SHPST_FK_actual_parent_table,
                    N'<NULL>'
                );

            PRINT N'            Expected Column                 : SHP_SHPST_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @SHP_SHPST_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : shipping.ShipmentStatus.SHPST_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE
                (
                    @SHP_SHPST_FK_actual_referenced_table,
                    N'<NULL>'
                );

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @SHP_SHPST_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE
                (
                    @SHP_SHPST_FK_actual_delete_action,
                    N'<NULL>'
                );

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE
                (
                    @SHP_SHPST_FK_actual_update_action,
                    N'<NULL>'
                );

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_SHPST_FK_actual_is_disabled
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
                        @SHP_SHPST_FK_actual_is_not_trusted
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

            @SHP_SHPST_FK_equivalent_name =
                fk.name,

            @SHP_SHPST_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @SHP_SHPST_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @SHP_SHPST_FK_equivalent_is_disabled =
                fk.is_disabled,

            @SHP_SHPST_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'shipping.ShipmentStatus')

        AND fk.name <>
                @SHP_SHPST_FK_expected_name

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
                    N'SHP_SHPST_id'

            AND rc.name =
                    N'SHPST_id'
        )

        ORDER BY fk.name;


        /*--------------------------------------------------------------------------
            EQUIVALENT FK EXISTS WITH ANOTHER NAME
        --------------------------------------------------------------------------*/

        IF @SHP_SHPST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_SHP_SHPST';

            PRINT N'            Actual Name                    : '
                + @SHP_SHPST_FK_equivalent_name;

            PRINT N'            Column                         : SHP_SHPST_id';

            PRINT N'            References                     : shipping.ShipmentStatus.SHPST_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE
                (
                    @SHP_SHPST_FK_equivalent_delete_action,
                    N'<NULL>'
                );

            PRINT N'            ON UPDATE                      : '
                + COALESCE
                (
                    @SHP_SHPST_FK_equivalent_update_action,
                    N'<NULL>'
                );

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_SHPST_FK_equivalent_is_disabled
                    ),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT
                    (
                        nvarchar(1),
                        @SHP_SHPST_FK_equivalent_is_not_trusted
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

            IF OBJECT_ID(N'shipping.FK_SHP_SHPST', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @SHP_SHPST_FK_conflict_parent =
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
                            N'shipping.FK_SHP_SHPST',
                            N'F'
                        );


                PRINT N'        [!] Foreign key name conflict       : FK_SHP_SHPST';
                PRINT N'            Expected Table                  : shipping.Shipment';
                PRINT N'            Existing Parent                 : '
                    + COALESCE
                    (
                        @SHP_SHPST_FK_conflict_parent,
                        N'<UNKNOWN>'
                    );

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 51266,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            /*==============================================================================
                CREATE FOREIGN KEY
            ==============================================================================*/

            ALTER TABLE shipping.Shipment
                WITH CHECK
                ADD CONSTRAINT FK_SHP_SHPST
                FOREIGN KEY
                (
                    SHP_SHPST_id
                )
                REFERENCES shipping.ShipmentStatus
                (
                    SHPST_id
                );


            ALTER TABLE shipping.Shipment
                CHECK CONSTRAINT FK_SHP_SHPST;


            PRINT N'        [+] Foreign key constraint added    : FK_SHP_SHPST';
            PRINT N'            Column                          : SHP_SHPST_id';
            PRINT N'            References                      : shipping.ShipmentStatus.SHPST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';