    PRINT N'    sales.Transaction';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FOREIGN KEY: FK_TRN_CST
    ==============================================================================*/

    DECLARE @TRN_CST_FK_actual_name               sysname;
    DECLARE @TRN_CST_FK_actual_parent_columns     nvarchar(4000);
    DECLARE @TRN_CST_FK_actual_referenced_columns nvarchar(4000);
    DECLARE @TRN_CST_FK_actual_delete_action      nvarchar(60);
    DECLARE @TRN_CST_FK_actual_update_action      nvarchar(60);
    DECLARE @TRN_CST_FK_actual_is_disabled        bit;
    DECLARE @TRN_CST_FK_actual_is_not_trusted     bit;
    DECLARE @TRN_CST_FK_equivalent_name           sysname;


    /*--------------------------------------------------------------------------
        DEPENDENCY VALIDATION
    --------------------------------------------------------------------------*/

    IF OBJECT_ID(N'sales.[Transaction]', N'U') IS NULL
    BEGIN

        ;THROW 50410,
            N'Foreign key FK_TRN_CST cannot be deployed because sales.Transaction does not exist.',
            1;

    END;


    IF OBJECT_ID(N'customer.Customer', N'U') IS NULL
    BEGIN

        ;THROW 50411,
            N'Foreign key FK_TRN_CST cannot be deployed because customer.Customer does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_CST_id') IS NULL
    OR COL_LENGTH(N'customer.Customer', N'CST_id') IS NULL
    BEGIN

        ;THROW 50412,
            N'Foreign key FK_TRN_CST cannot be deployed because one or more participating columns do not exist.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS p

        INNER JOIN sys.columns AS r
            ON r.object_id =
                OBJECT_ID(N'customer.Customer')

        AND r.name =
            N'CST_id'

        WHERE p.object_id =
            OBJECT_ID(N'sales.[Transaction]')

        AND p.name =
            N'TRN_CST_id'

        AND p.system_type_id =
            r.system_type_id

        AND p.max_length =
            r.max_length

        AND p.precision =
            r.precision

        AND p.scale =
            r.scale

        AND TYPE_NAME(p.user_type_id) =
            N'int'

        AND TYPE_NAME(r.user_type_id) =
            N'int'

        AND p.is_nullable = 1

        AND r.is_nullable = 0
    )
    BEGIN

        ;THROW 50413,
            N'Foreign key FK_TRN_CST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_TRN_CST';


    /*--------------------------------------------------------------------------
        LOOK FOR EXPECTED NAME
    --------------------------------------------------------------------------*/

    SELECT
        @TRN_CST_FK_actual_name =
            fk.name,

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
                ON pc.object_id =
                    fkc.parent_object_id

            AND pc.column_id =
                fkc.parent_column_id

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
                ON rc.object_id =
                    fkc.referenced_object_id

            AND rc.column_id =
                fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
        OBJECT_ID(N'sales.[Transaction]')

    AND fk.name =
        N'FK_TRN_CST';


    IF @TRN_CST_FK_actual_name IS NOT NULL
    BEGIN

        IF @TRN_CST_FK_actual_parent_columns =
            N'TRN_CST_id'

        AND @TRN_CST_FK_actual_referenced_columns =
            N'CST_id'

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_keys

            WHERE parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')

            AND name =
                N'FK_TRN_CST'

            AND referenced_object_id =
                OBJECT_ID(N'customer.Customer')
        )

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

            PRINT N'        [X] Foreign key mismatch             : FK_TRN_CST';

            ;THROW 50414,
                N'Foreign key FK_TRN_CST exists but does not match the expected definition.',
                1;

        END;

    END
    ELSE
    BEGIN

        SELECT TOP (1)
            @TRN_CST_FK_equivalent_name =
                fk.name

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
            OBJECT_ID(N'sales.[Transaction]')

        AND fk.referenced_object_id =
            OBJECT_ID(N'customer.Customer')

        AND fk.name <>
            N'FK_TRN_CST'

        AND fk.delete_referential_action_desc =
            N'NO_ACTION'

        AND fk.update_referential_action_desc =
            N'NO_ACTION'

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
                ON pc.object_id =
                    fkc.parent_object_id
                AND pc.column_id =
                    fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON rc.object_id =
                    fkc.referenced_object_id
                AND rc.column_id =
                    fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                fk.object_id

            AND pc.name =
                N'TRN_CST_id'

            AND rc.name =
                N'CST_id'
        );


        IF @TRN_CST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [X] Foreign key naming mismatch      : FK_TRN_CST';
            PRINT N'            Actual Name                     : '
                + @TRN_CST_FK_equivalent_name;

            ;THROW 50415,
                N'An equivalent foreign key for FK_TRN_CST exists with another name.',
                1;

        END;


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
            )
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;


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


    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_TRN_TRNST
    ==============================================================================*/

    DECLARE @TRN_TRNST_FK_actual_name               sysname;
    DECLARE @TRN_TRNST_FK_actual_parent_columns     nvarchar(4000);
    DECLARE @TRN_TRNST_FK_actual_referenced_columns nvarchar(4000);
    DECLARE @TRN_TRNST_FK_actual_delete_action      nvarchar(60);
    DECLARE @TRN_TRNST_FK_actual_update_action      nvarchar(60);
    DECLARE @TRN_TRNST_FK_actual_is_disabled        bit;
    DECLARE @TRN_TRNST_FK_actual_is_not_trusted     bit;
    DECLARE @TRN_TRNST_FK_equivalent_name           sysname;


    /*--------------------------------------------------------------------------
        DEPENDENCY VALIDATION
    --------------------------------------------------------------------------*/

    IF OBJECT_ID(N'sales.TransactionStatus', N'U') IS NULL
    BEGIN

        ;THROW 50416,
            N'Foreign key FK_TRN_TRNST cannot be deployed because sales.TransactionStatus does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_TRNST_id') IS NULL
    OR COL_LENGTH(N'sales.TransactionStatus', N'TRNST_id') IS NULL
    BEGIN

        ;THROW 50417,
            N'Foreign key FK_TRN_TRNST cannot be deployed because one or more participating columns do not exist.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS p

        INNER JOIN sys.columns AS r
            ON r.object_id =
                OBJECT_ID(N'sales.TransactionStatus')

        AND r.name =
            N'TRNST_id'

        WHERE p.object_id =
            OBJECT_ID(N'sales.[Transaction]')

        AND p.name =
            N'TRN_TRNST_id'

        AND p.system_type_id =
            r.system_type_id

        AND p.max_length =
            r.max_length

        AND p.precision =
            r.precision

        AND p.scale =
            r.scale

        AND TYPE_NAME(p.user_type_id) =
            N'tinyint'

        AND TYPE_NAME(r.user_type_id) =
            N'tinyint'

        AND p.is_nullable = 0

        AND r.is_nullable = 0
    )
    BEGIN

        ;THROW 50418,
            N'Foreign key FK_TRN_TRNST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_TRN_TRNST';


    /*--------------------------------------------------------------------------
        LOOK FOR EXPECTED NAME
    --------------------------------------------------------------------------*/

    SELECT
        @TRN_TRNST_FK_actual_name =
            fk.name,

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
                ON pc.object_id =
                    fkc.parent_object_id
                AND pc.column_id =
                    fkc.parent_column_id

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
                ON rc.object_id =
                    fkc.referenced_object_id
                AND rc.column_id =
                    fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
        OBJECT_ID(N'sales.[Transaction]')

    AND fk.name =
        N'FK_TRN_TRNST';


    IF @TRN_TRNST_FK_actual_name IS NOT NULL
    BEGIN

        IF @TRN_TRNST_FK_actual_parent_columns =
            N'TRN_TRNST_id'

        AND @TRN_TRNST_FK_actual_referenced_columns =
            N'TRNST_id'

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_keys

            WHERE parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')

            AND name =
                N'FK_TRN_TRNST'

            AND referenced_object_id =
                OBJECT_ID(N'sales.TransactionStatus')
        )

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

            PRINT N'        [X] Foreign key mismatch             : FK_TRN_TRNST';

            ;THROW 50419,
                N'Foreign key FK_TRN_TRNST exists but does not match the expected definition.',
                1;

        END;

    END
    ELSE
    BEGIN

        SELECT TOP (1)
            @TRN_TRNST_FK_equivalent_name =
                fk.name

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
            OBJECT_ID(N'sales.[Transaction]')

        AND fk.referenced_object_id =
            OBJECT_ID(N'sales.TransactionStatus')

        AND fk.name <>
            N'FK_TRN_TRNST'

        AND fk.delete_referential_action_desc =
            N'NO_ACTION'

        AND fk.update_referential_action_desc =
            N'NO_ACTION'

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
                ON pc.object_id =
                    fkc.parent_object_id
                AND pc.column_id =
                    fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON rc.object_id =
                    fkc.referenced_object_id
                AND rc.column_id =
                    fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                fk.object_id

            AND pc.name =
                N'TRN_TRNST_id'

            AND rc.name =
                N'TRNST_id'
        );


        IF @TRN_TRNST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [X] Foreign key naming mismatch      : FK_TRN_TRNST';
            PRINT N'            Actual Name                     : '
                + @TRN_TRNST_FK_equivalent_name;

            ;THROW 50420,
                N'An equivalent foreign key for FK_TRN_TRNST exists with another name.',
                1;

        END;


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
            )
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;


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


    PRINT N'';


    /*==============================================================================
        FOREIGN KEY: FK_TRN_TRNCH
    ==============================================================================*/

    DECLARE @TRN_TRNCH_FK_actual_name               sysname;
    DECLARE @TRN_TRNCH_FK_actual_parent_columns     nvarchar(4000);
    DECLARE @TRN_TRNCH_FK_actual_referenced_columns nvarchar(4000);
    DECLARE @TRN_TRNCH_FK_actual_delete_action      nvarchar(60);
    DECLARE @TRN_TRNCH_FK_actual_update_action      nvarchar(60);
    DECLARE @TRN_TRNCH_FK_actual_is_disabled        bit;
    DECLARE @TRN_TRNCH_FK_actual_is_not_trusted     bit;
    DECLARE @TRN_TRNCH_FK_equivalent_name           sysname;


    /*--------------------------------------------------------------------------
        DEPENDENCY VALIDATION
    --------------------------------------------------------------------------*/

    IF OBJECT_ID(N'sales.TransactionChannel', N'U') IS NULL
    BEGIN

        ;THROW 50421,
            N'Foreign key FK_TRN_TRNCH cannot be deployed because sales.TransactionChannel does not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_TRNCH_id') IS NULL
    OR COL_LENGTH(N'sales.TransactionChannel', N'TRNCH_id') IS NULL
    BEGIN

        ;THROW 50422,
            N'Foreign key FK_TRN_TRNCH cannot be deployed because one or more participating columns do not exist.',
            1;

    END;


    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS p

        INNER JOIN sys.columns AS r
            ON r.object_id =
                OBJECT_ID(N'sales.TransactionChannel')

        AND r.name =
            N'TRNCH_id'

        WHERE p.object_id =
            OBJECT_ID(N'sales.[Transaction]')

        AND p.name =
            N'TRN_TRNCH_id'

        AND p.system_type_id =
            r.system_type_id

        AND p.max_length =
            r.max_length

        AND p.precision =
            r.precision

        AND p.scale =
            r.scale

        AND TYPE_NAME(p.user_type_id) =
            N'tinyint'

        AND TYPE_NAME(r.user_type_id) =
            N'tinyint'

        AND p.is_nullable = 0

        AND r.is_nullable = 0
    )
    BEGIN

        ;THROW 50423,
            N'Foreign key FK_TRN_TRNCH cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_TRN_TRNCH';


    /*--------------------------------------------------------------------------
        LOOK FOR EXPECTED NAME
    --------------------------------------------------------------------------*/

    SELECT
        @TRN_TRNCH_FK_actual_name =
            fk.name,

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
                ON pc.object_id =
                    fkc.parent_object_id
                AND pc.column_id =
                    fkc.parent_column_id

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
                ON rc.object_id =
                    fkc.referenced_object_id
                AND rc.column_id =
                    fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
        OBJECT_ID(N'sales.[Transaction]')

    AND fk.name =
        N'FK_TRN_TRNCH';


    IF @TRN_TRNCH_FK_actual_name IS NOT NULL
    BEGIN

        IF @TRN_TRNCH_FK_actual_parent_columns =
            N'TRN_TRNCH_id'

        AND @TRN_TRNCH_FK_actual_referenced_columns =
            N'TRNCH_id'

        AND EXISTS
        (
            SELECT 1

            FROM sys.foreign_keys

            WHERE parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')

            AND name =
                N'FK_TRN_TRNCH'

            AND referenced_object_id =
                OBJECT_ID(N'sales.TransactionChannel')
        )

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

            PRINT N'        [X] Foreign key mismatch             : FK_TRN_TRNCH';

            ;THROW 50424,
                N'Foreign key FK_TRN_TRNCH exists but does not match the expected definition.',
                1;

        END;

    END
    ELSE
    BEGIN

        SELECT TOP (1)
            @TRN_TRNCH_FK_equivalent_name =
                fk.name

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
            OBJECT_ID(N'sales.[Transaction]')

        AND fk.referenced_object_id =
            OBJECT_ID(N'sales.TransactionChannel')

        AND fk.name <>
            N'FK_TRN_TRNCH'

        AND fk.delete_referential_action_desc =
            N'NO_ACTION'

        AND fk.update_referential_action_desc =
            N'NO_ACTION'

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
                ON pc.object_id =
                    fkc.parent_object_id
                AND pc.column_id =
                    fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON rc.object_id =
                    fkc.referenced_object_id
                AND rc.column_id =
                    fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                fk.object_id

            AND pc.name =
                N'TRN_TRNCH_id'

            AND rc.name =
                N'TRNCH_id'
        );


        IF @TRN_TRNCH_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [X] Foreign key naming mismatch      : FK_TRN_TRNCH';
            PRINT N'            Actual Name                     : '
                + @TRN_TRNCH_FK_equivalent_name;

            ;THROW 50425,
                N'An equivalent foreign key for FK_TRN_TRNCH exists with another name.',
                1;

        END;


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
            )
            ON DELETE NO ACTION
            ON UPDATE NO ACTION;


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


    PRINT N'';