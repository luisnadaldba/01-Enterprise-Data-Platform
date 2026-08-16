    PRINT N'    customer.CustomerAddress';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FOREIGN KEY: FK_CSTAD_CST
    ==============================================================================*/

    DECLARE @CSTAD_CST_FK_expected_name                sysname;
    DECLARE @CSTAD_CST_FK_actual_name                  sysname;

    DECLARE @CSTAD_CST_FK_actual_parent_table          nvarchar(517);
    DECLARE @CSTAD_CST_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CSTAD_CST_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CSTAD_CST_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CSTAD_CST_FK_actual_delete_action         nvarchar(60);
    DECLARE @CSTAD_CST_FK_actual_update_action         nvarchar(60);

    DECLARE @CSTAD_CST_FK_actual_is_disabled           bit;
    DECLARE @CSTAD_CST_FK_actual_is_not_trusted        bit;

    DECLARE @CSTAD_CST_FK_equivalent_name              sysname;
    DECLARE @CSTAD_CST_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CSTAD_CST_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CSTAD_CST_FK_equivalent_is_disabled       bit;
    DECLARE @CSTAD_CST_FK_equivalent_is_not_trusted    bit;

    DECLARE @CSTAD_CST_FK_conflict_parent              nvarchar(517);


    SET @CSTAD_CST_FK_expected_name = N'FK_CSTAD_CST';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerAddress', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.CustomerAddress';

        ;THROW 50470,
            N'Foreign key FK_CSTAD_CST cannot be deployed because customer.CustomerAddress does not exist.',
            1;

    END;


    IF OBJECT_ID(N'customer.Customer', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.Customer';

        ;THROW 50471,
            N'Foreign key FK_CSTAD_CST cannot be deployed because customer.Customer does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerAddress', N'CSTAD_CST_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CSTAD_CST_id';

        ;THROW 50472,
            N'Foreign key FK_CSTAD_CST cannot be deployed because CSTAD_CST_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.Customer', N'CST_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CST_id';

        ;THROW 50473,
            N'Foreign key FK_CSTAD_CST cannot be deployed because referenced column customer.Customer.CST_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CSTAD_CST_id -> int NOT NULL
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
                OBJECT_ID(N'customer.CustomerAddress')

        AND parent_column.name =
                N'CSTAD_CST_id'

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

        PRINT N'        [X] Foreign key column mismatch    : CSTAD_CST_id -> CST_id';

        ;THROW 50474,
            N'Foreign key FK_CSTAD_CST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_CSTAD_CST';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @CSTAD_CST_FK_actual_name =
            fk.name,

        @CSTAD_CST_FK_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @CSTAD_CST_FK_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @CSTAD_CST_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CSTAD_CST_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CSTAD_CST_FK_actual_is_disabled =
            fk.is_disabled,

        @CSTAD_CST_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CSTAD_CST_FK_actual_parent_columns =
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

        @CSTAD_CST_FK_actual_referenced_columns =
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
            OBJECT_ID(N'customer.CustomerAddress')

    AND fk.name =
            @CSTAD_CST_FK_expected_name;


    IF @CSTAD_CST_FK_actual_name IS NOT NULL
    BEGIN

        IF @CSTAD_CST_FK_actual_parent_table =
                N'[customer].[CustomerAddress]'

        AND @CSTAD_CST_FK_actual_parent_columns =
                N'CSTAD_CST_id'

        AND @CSTAD_CST_FK_actual_referenced_table =
                N'[customer].[Customer]'

        AND @CSTAD_CST_FK_actual_referenced_columns =
                N'CST_id'

        AND @CSTAD_CST_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CSTAD_CST_FK_actual_update_action =
                N'NO_ACTION'

        AND @CSTAD_CST_FK_actual_is_disabled = 0

        AND @CSTAD_CST_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CSTAD_CST';
            PRINT N'            Column                          : CSTAD_CST_id';
            PRINT N'            References                      : customer.Customer.CST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CSTAD_CST';

            PRINT N'            Expected Table                  : customer.CustomerAddress';
            PRINT N'            Actual Table                    : '
                + COALESCE(@CSTAD_CST_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : CSTAD_CST_id';
            PRINT N'            Actual Column                   : '
                + COALESCE(@CSTAD_CST_FK_actual_parent_columns, N'<NULL>');

            PRINT N'            Expected Reference              : customer.Customer.CST_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@CSTAD_CST_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE(@CSTAD_CST_FK_actual_referenced_columns, N'<NULL>');

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@CSTAD_CST_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@CSTAD_CST_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTAD_CST_FK_actual_is_disabled),
                    N'<NULL>'
                );

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CSTAD_CST_FK_actual_is_not_trusted),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END
    ELSE
    BEGIN

        SELECT TOP (1)

            @CSTAD_CST_FK_equivalent_name =
                fk.name,

            @CSTAD_CST_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CSTAD_CST_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CSTAD_CST_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CSTAD_CST_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerAddress')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.name <>
                @CSTAD_CST_FK_expected_name

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
                    N'CSTAD_CST_id'

            AND rc.name =
                    N'CST_id'
        )

        ORDER BY fk.name;


        IF @CSTAD_CST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';
            PRINT N'            Expected Name                  : FK_CSTAD_CST';
            PRINT N'            Actual Name                    : '
                + @CSTAD_CST_FK_equivalent_name;
            PRINT N'            Column                         : CSTAD_CST_id';
            PRINT N'            References                     : customer.Customer.CST_id';
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            IF OBJECT_ID(N'customer.FK_CSTAD_CST', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CSTAD_CST_FK_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'customer.FK_CSTAD_CST', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_CSTAD_CST';
                PRINT N'            Expected Table                  : customer.CustomerAddress';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@CSTAD_CST_FK_conflict_parent, N'<UNKNOWN>');
                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50475,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            ALTER TABLE customer.CustomerAddress
                WITH CHECK
                ADD CONSTRAINT FK_CSTAD_CST
                FOREIGN KEY
                (
                    CSTAD_CST_id
                )
                REFERENCES customer.Customer
                (
                    CST_id
                );


            ALTER TABLE customer.CustomerAddress
                CHECK CONSTRAINT FK_CSTAD_CST;


            PRINT N'        [+] Foreign key constraint added    : FK_CSTAD_CST';
            PRINT N'            Column                          : CSTAD_CST_id';
            PRINT N'            References                      : customer.Customer.CST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_CSTAD_ADR
    ==============================================================================*/

    DECLARE @CSTAD_ADR_FK_expected_name                sysname;
    DECLARE @CSTAD_ADR_FK_actual_name                  sysname;

    DECLARE @CSTAD_ADR_FK_actual_parent_table          nvarchar(517);
    DECLARE @CSTAD_ADR_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CSTAD_ADR_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CSTAD_ADR_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CSTAD_ADR_FK_actual_delete_action         nvarchar(60);
    DECLARE @CSTAD_ADR_FK_actual_update_action         nvarchar(60);

    DECLARE @CSTAD_ADR_FK_actual_is_disabled           bit;
    DECLARE @CSTAD_ADR_FK_actual_is_not_trusted        bit;

    DECLARE @CSTAD_ADR_FK_equivalent_name              sysname;
    DECLARE @CSTAD_ADR_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CSTAD_ADR_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CSTAD_ADR_FK_equivalent_is_disabled       bit;
    DECLARE @CSTAD_ADR_FK_equivalent_is_not_trusted    bit;

    DECLARE @CSTAD_ADR_FK_conflict_parent              nvarchar(517);


    SET @CSTAD_ADR_FK_expected_name = N'FK_CSTAD_ADR';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'reference.Address', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.Address';

        ;THROW 50476,
            N'Foreign key FK_CSTAD_ADR cannot be deployed because reference.Address does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerAddress', N'CSTAD_ADR_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CSTAD_ADR_id';

        ;THROW 50477,
            N'Foreign key FK_CSTAD_ADR cannot be deployed because CSTAD_ADR_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.Address', N'ADR_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : ADR_id';

        ;THROW 50478,
            N'Foreign key FK_CSTAD_ADR cannot be deployed because referenced column reference.Address.ADR_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'reference.Address')

        WHERE parent_column.object_id =
                OBJECT_ID(N'customer.CustomerAddress')

        AND parent_column.name =
                N'CSTAD_ADR_id'

        AND referenced_column.name =
                N'ADR_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : CSTAD_ADR_id -> ADR_id';

        ;THROW 50479,
            N'Foreign key FK_CSTAD_ADR cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_CSTAD_ADR';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @CSTAD_ADR_FK_actual_name =
            fk.name,

        @CSTAD_ADR_FK_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @CSTAD_ADR_FK_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @CSTAD_ADR_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CSTAD_ADR_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CSTAD_ADR_FK_actual_is_disabled =
            fk.is_disabled,

        @CSTAD_ADR_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CSTAD_ADR_FK_actual_parent_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
            WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ),

        @CSTAD_ADR_FK_actual_referenced_columns =
        (
            SELECT STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
            WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'customer.CustomerAddress')

    AND fk.name =
            @CSTAD_ADR_FK_expected_name;


    IF @CSTAD_ADR_FK_actual_name IS NOT NULL
    BEGIN

        IF @CSTAD_ADR_FK_actual_parent_table =
                N'[customer].[CustomerAddress]'

        AND @CSTAD_ADR_FK_actual_parent_columns =
                N'CSTAD_ADR_id'

        AND @CSTAD_ADR_FK_actual_referenced_table =
                N'[reference].[Address]'

        AND @CSTAD_ADR_FK_actual_referenced_columns =
                N'ADR_id'

        AND @CSTAD_ADR_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CSTAD_ADR_FK_actual_update_action =
                N'NO_ACTION'

        AND @CSTAD_ADR_FK_actual_is_disabled = 0

        AND @CSTAD_ADR_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CSTAD_ADR';
            PRINT N'            Column                          : CSTAD_ADR_id';
            PRINT N'            References                      : reference.Address.ADR_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CSTAD_ADR';
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END
    ELSE
    BEGIN

        SELECT TOP (1)

            @CSTAD_ADR_FK_equivalent_name =
                fk.name,

            @CSTAD_ADR_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CSTAD_ADR_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CSTAD_ADR_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CSTAD_ADR_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerAddress')

        AND fk.referenced_object_id =
                OBJECT_ID(N'reference.Address')

        AND fk.name <>
                @CSTAD_ADR_FK_expected_name

        AND fk.delete_referential_action = 0

        AND fk.update_referential_action = 0

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 1

        AND EXISTS
        (
            SELECT 1
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
            AND pc.name = N'CSTAD_ADR_id'
            AND rc.name = N'ADR_id'
        )

        ORDER BY fk.name;


        IF @CSTAD_ADR_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';
            PRINT N'            Expected Name                  : FK_CSTAD_ADR';
            PRINT N'            Actual Name                    : '
                + @CSTAD_ADR_FK_equivalent_name;
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            IF OBJECT_ID(N'customer.FK_CSTAD_ADR', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CSTAD_ADR_FK_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'customer.FK_CSTAD_ADR', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_CSTAD_ADR';
                PRINT N'            Expected Table                  : customer.CustomerAddress';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@CSTAD_ADR_FK_conflict_parent, N'<UNKNOWN>');
                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50480,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            ALTER TABLE customer.CustomerAddress
                WITH CHECK
                ADD CONSTRAINT FK_CSTAD_ADR
                FOREIGN KEY
                (
                    CSTAD_ADR_id
                )
                REFERENCES reference.Address
                (
                    ADR_id
                );


            ALTER TABLE customer.CustomerAddress
                CHECK CONSTRAINT FK_CSTAD_ADR;


            PRINT N'        [+] Foreign key constraint added    : FK_CSTAD_ADR';
            PRINT N'            Column                          : CSTAD_ADR_id';
            PRINT N'            References                      : reference.Address.ADR_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';