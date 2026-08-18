    PRINT N'    shipping.Shipment';
    PRINT N'    --------------------------------------------------------------------------';


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
    DECLARE @SHP_TRN_FK_conflict_parent              nvarchar(517);


    SET @SHP_TRN_FK_expected_name = N'FK_SHP_TRN';


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
    OR COL_LENGTH(N'shipping.Shipment', N'SHP_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key columns missing    : SHP_TRN_id, SHP_transaction_at';

        ;THROW 51242,
            N'Foreign key FK_SHP_TRN cannot be deployed because participating columns do not exist.',
            1;

    END;


    IF COL_LENGTH(N'sales.[Transaction]', N'TRN_id') IS NULL
    OR COL_LENGTH(N'sales.[Transaction]', N'TRN_transaction_at') IS NULL
    BEGIN

        PRINT N'        [X] Referenced columns missing     : TRN_id, TRN_transaction_at';

        ;THROW 51243,
            N'Foreign key FK_SHP_TRN cannot be deployed because referenced columns do not exist.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_SHP_TRN';


    SELECT
        @SHP_TRN_FK_actual_name =
            fk.name,

        @SHP_TRN_FK_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @SHP_TRN_FK_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

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
                STRING_AGG(CONVERT(nvarchar(max), pc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        ),

        @SHP_TRN_FK_actual_referenced_columns =
        (
            SELECT
                STRING_AGG(CONVERT(nvarchar(max), rc.name), N'|')
                WITHIN GROUP (ORDER BY fkc.constraint_column_id)
            FROM sys.foreign_key_columns AS fkc
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fkc.constraint_object_id = fk.object_id
        )

    FROM sys.foreign_keys AS fk

    WHERE fk.parent_object_id =
            OBJECT_ID(N'shipping.Shipment')

    AND fk.name =
            @SHP_TRN_FK_expected_name;


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

        AND @SHP_TRN_FK_actual_delete_action = N'NO_ACTION'
        AND @SHP_TRN_FK_actual_update_action = N'NO_ACTION'
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
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END
    ELSE
    BEGIN

        SELECT TOP (1)
            @SHP_TRN_FK_equivalent_name = fk.name

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'shipping.Shipment')

        AND fk.referenced_object_id =
                OBJECT_ID(N'sales.[Transaction]')

        AND
        (
            SELECT COUNT(*)
            FROM sys.foreign_key_columns AS fkc
            WHERE fkc.constraint_object_id = fk.object_id
        ) = 2

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
            AND fkc.constraint_column_id = 1
            AND pc.name = N'SHP_TRN_id'
            AND rc.name = N'TRN_id'
        )

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
            AND fkc.constraint_column_id = 2
            AND pc.name = N'SHP_transaction_at'
            AND rc.name = N'TRN_transaction_at'
        );


        IF @SHP_TRN_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';
            PRINT N'            Expected Name                  : FK_SHP_TRN';
            PRINT N'            Actual Name                    : '
                + @SHP_TRN_FK_equivalent_name;
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            IF OBJECT_ID(N'shipping.FK_SHP_TRN', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @SHP_TRN_FK_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))
                FROM sys.foreign_keys AS fk
                WHERE fk.object_id =
                        OBJECT_ID(N'shipping.FK_SHP_TRN', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_SHP_TRN';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@SHP_TRN_FK_conflict_parent, N'<UNKNOWN>');

                ;THROW 51244,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


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

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'shipping.Shipment')
        AND fk.name = N'FK_SHP_CSTAD'
    )
    BEGIN

        IF OBJECT_ID(N'customer.CustomerAddress', N'U') IS NULL
        BEGIN

            PRINT N'        [X] Foreign key dependency missing : customer.CustomerAddress';

            ;THROW 51245,
                N'Foreign key FK_SHP_CSTAD cannot be deployed because customer.CustomerAddress does not exist.',
                1;

        END;


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

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM sys.foreign_keys AS fk
            INNER JOIN sys.foreign_key_columns AS fkc
                ON fkc.constraint_object_id = fk.object_id
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fk.parent_object_id = OBJECT_ID(N'shipping.Shipment')
            AND fk.referenced_object_id = OBJECT_ID(N'customer.CustomerAddress')
            AND fk.name = N'FK_SHP_CSTAD'
            AND pc.name = N'SHP_CSTAD_id'
            AND rc.name = N'CSTAD_id'
            AND fk.delete_referential_action = 0
            AND fk.update_referential_action = 0
            AND fk.is_disabled = 0
            AND fk.is_not_trusted = 0
        )
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
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_SHP_SHPMT
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'shipping.Shipment')
        AND fk.name = N'FK_SHP_SHPMT'
    )
    BEGIN

        IF OBJECT_ID(N'shipping.ShipmentMethod', N'U') IS NULL
        BEGIN

            PRINT N'        [X] Foreign key dependency missing : shipping.ShipmentMethod';

            ;THROW 51246,
                N'Foreign key FK_SHP_SHPMT cannot be deployed because shipping.ShipmentMethod does not exist.',
                1;

        END;


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

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM sys.foreign_keys AS fk
            INNER JOIN sys.foreign_key_columns AS fkc
                ON fkc.constraint_object_id = fk.object_id
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fk.parent_object_id = OBJECT_ID(N'shipping.Shipment')
            AND fk.referenced_object_id = OBJECT_ID(N'shipping.ShipmentMethod')
            AND fk.name = N'FK_SHP_SHPMT'
            AND pc.name = N'SHP_SHPMT_id'
            AND rc.name = N'SHPMT_id'
            AND fk.delete_referential_action = 0
            AND fk.update_referential_action = 0
            AND fk.is_disabled = 0
            AND fk.is_not_trusted = 0
        )
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
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_SHP_SHPST
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.foreign_keys AS fk
        WHERE fk.parent_object_id = OBJECT_ID(N'shipping.Shipment')
        AND fk.name = N'FK_SHP_SHPST'
    )
    BEGIN

        IF OBJECT_ID(N'shipping.ShipmentStatus', N'U') IS NULL
        BEGIN

            PRINT N'        [X] Foreign key dependency missing : shipping.ShipmentStatus';

            ;THROW 51247,
                N'Foreign key FK_SHP_SHPST cannot be deployed because shipping.ShipmentStatus does not exist.',
                1;

        END;


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

    END
    ELSE
    BEGIN

        IF EXISTS
        (
            SELECT 1
            FROM sys.foreign_keys AS fk
            INNER JOIN sys.foreign_key_columns AS fkc
                ON fkc.constraint_object_id = fk.object_id
            INNER JOIN sys.columns AS pc
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id
            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id
            WHERE fk.parent_object_id = OBJECT_ID(N'shipping.Shipment')
            AND fk.referenced_object_id = OBJECT_ID(N'shipping.ShipmentStatus')
            AND fk.name = N'FK_SHP_SHPST'
            AND pc.name = N'SHP_SHPST_id'
            AND rc.name = N'SHPST_id'
            AND fk.delete_referential_action = 0
            AND fk.update_referential_action = 0
            AND fk.is_disabled = 0
            AND fk.is_not_trusted = 0
        )
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
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';