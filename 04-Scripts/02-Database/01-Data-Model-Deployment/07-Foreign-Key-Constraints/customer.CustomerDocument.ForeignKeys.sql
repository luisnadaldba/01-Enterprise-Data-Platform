    PRINT N'    customer.CustomerDocument';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FOREIGN KEY: FK_CSTCD_CST
    ==============================================================================*/

    DECLARE @CSTCD_CST_FK_expected_name                sysname;
    DECLARE @CSTCD_CST_FK_actual_name                  sysname;

    DECLARE @CSTCD_CST_FK_actual_parent_table          nvarchar(517);
    DECLARE @CSTCD_CST_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CSTCD_CST_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CSTCD_CST_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CSTCD_CST_FK_actual_delete_action         nvarchar(60);
    DECLARE @CSTCD_CST_FK_actual_update_action         nvarchar(60);

    DECLARE @CSTCD_CST_FK_actual_is_disabled           bit;
    DECLARE @CSTCD_CST_FK_actual_is_not_trusted        bit;

    DECLARE @CSTCD_CST_FK_equivalent_name              sysname;
    DECLARE @CSTCD_CST_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CSTCD_CST_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CSTCD_CST_FK_equivalent_is_disabled       bit;
    DECLARE @CSTCD_CST_FK_equivalent_is_not_trusted    bit;

    DECLARE @CSTCD_CST_FK_conflict_parent              nvarchar(517);


    SET @CSTCD_CST_FK_expected_name = N'FK_CSTCD_CST';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerDocument', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.CustomerDocument';

        ;THROW 50570,
            N'Foreign key FK_CSTCD_CST cannot be deployed because customer.CustomerDocument does not exist.',
            1;

    END;


    IF OBJECT_ID(N'customer.Customer', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.Customer';

        ;THROW 50571,
            N'Foreign key FK_CSTCD_CST cannot be deployed because customer.Customer does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerDocument', N'CSTCD_CST_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CSTCD_CST_id';

        ;THROW 50572,
            N'Foreign key FK_CSTCD_CST cannot be deployed because CSTCD_CST_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.Customer', N'CST_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CST_id';

        ;THROW 50573,
            N'Foreign key FK_CSTCD_CST cannot be deployed because referenced column customer.Customer.CST_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CSTCD_CST_id -> int NOT NULL
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
                OBJECT_ID(N'customer.CustomerDocument')

        AND parent_column.name =
                N'CSTCD_CST_id'

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

        PRINT N'        [X] Foreign key column mismatch    : CSTCD_CST_id -> CST_id';

        ;THROW 50574,
            N'Foreign key FK_CSTCD_CST cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_CSTCD_CST';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @CSTCD_CST_FK_actual_name =
            fk.name,

        @CSTCD_CST_FK_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @CSTCD_CST_FK_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @CSTCD_CST_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CSTCD_CST_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CSTCD_CST_FK_actual_is_disabled =
            fk.is_disabled,

        @CSTCD_CST_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CSTCD_CST_FK_actual_parent_columns =
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

        @CSTCD_CST_FK_actual_referenced_columns =
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
            OBJECT_ID(N'customer.CustomerDocument')

    AND fk.name =
            @CSTCD_CST_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @CSTCD_CST_FK_actual_name IS NOT NULL
    BEGIN

        IF @CSTCD_CST_FK_actual_parent_table =
                N'[customer].[CustomerDocument]'

        AND @CSTCD_CST_FK_actual_parent_columns =
                N'CSTCD_CST_id'

        AND @CSTCD_CST_FK_actual_referenced_table =
                N'[customer].[Customer]'

        AND @CSTCD_CST_FK_actual_referenced_columns =
                N'CST_id'

        AND @CSTCD_CST_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CSTCD_CST_FK_actual_update_action =
                N'NO_ACTION'

        AND @CSTCD_CST_FK_actual_is_disabled = 0

        AND @CSTCD_CST_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CSTCD_CST';
            PRINT N'            Column                          : CSTCD_CST_id';
            PRINT N'            References                      : customer.Customer.CST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CSTCD_CST';

            PRINT N'            Expected Table                  : customer.CustomerDocument';
            PRINT N'            Actual Table                    : '
                + COALESCE(@CSTCD_CST_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : CSTCD_CST_id';
            PRINT N'            Actual Column                   : '
                + COALESCE(@CSTCD_CST_FK_actual_parent_columns, N'<NULL>');

            PRINT N'            Expected Reference              : customer.Customer.CST_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@CSTCD_CST_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE(@CSTCD_CST_FK_actual_referenced_columns, N'<NULL>');

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@CSTCD_CST_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@CSTCD_CST_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE(CONVERT(nvarchar(1), @CSTCD_CST_FK_actual_is_disabled), N'<NULL>');

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE(CONVERT(nvarchar(1), @CSTCD_CST_FK_actual_is_not_trusted), N'<NULL>');

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END
    ELSE
    BEGIN

        /*==========================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==========================================================================*/

        SELECT TOP (1)

            @CSTCD_CST_FK_equivalent_name =
                fk.name,

            @CSTCD_CST_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CSTCD_CST_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CSTCD_CST_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CSTCD_CST_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.name <>
                @CSTCD_CST_FK_expected_name

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
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'CSTCD_CST_id'

            AND rc.name =
                    N'CST_id'
        )

        ORDER BY fk.name;


        IF @CSTCD_CST_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';
            PRINT N'            Expected Name                  : FK_CSTCD_CST';
            PRINT N'            Actual Name                    : '
                + @CSTCD_CST_FK_equivalent_name;
            PRINT N'            Column                         : CSTCD_CST_id';
            PRINT N'            References                     : customer.Customer.CST_id';
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            IF OBJECT_ID(N'customer.FK_CSTCD_CST', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CSTCD_CST_FK_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'customer.FK_CSTCD_CST', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_CSTCD_CST';
                PRINT N'            Expected Table                  : customer.CustomerDocument';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@CSTCD_CST_FK_conflict_parent, N'<UNKNOWN>');
                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50575,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            ALTER TABLE customer.CustomerDocument
                WITH CHECK
                ADD CONSTRAINT FK_CSTCD_CST
                FOREIGN KEY
                (
                    CSTCD_CST_id
                )
                REFERENCES customer.Customer
                (
                    CST_id
                );


            ALTER TABLE customer.CustomerDocument
                CHECK CONSTRAINT FK_CSTCD_CST;


            PRINT N'        [+] Foreign key constraint added    : FK_CSTCD_CST';
            PRINT N'            Column                          : CSTCD_CST_id';
            PRINT N'            References                      : customer.Customer.CST_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_CSTCD_DTP
    ==============================================================================*/

    DECLARE @CSTCD_DTP_FK_expected_name                sysname;
    DECLARE @CSTCD_DTP_FK_actual_name                  sysname;

    DECLARE @CSTCD_DTP_FK_actual_parent_table          nvarchar(517);
    DECLARE @CSTCD_DTP_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CSTCD_DTP_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CSTCD_DTP_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CSTCD_DTP_FK_actual_delete_action         nvarchar(60);
    DECLARE @CSTCD_DTP_FK_actual_update_action         nvarchar(60);

    DECLARE @CSTCD_DTP_FK_actual_is_disabled           bit;
    DECLARE @CSTCD_DTP_FK_actual_is_not_trusted        bit;

    DECLARE @CSTCD_DTP_FK_equivalent_name              sysname;
    DECLARE @CSTCD_DTP_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CSTCD_DTP_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CSTCD_DTP_FK_equivalent_is_disabled       bit;
    DECLARE @CSTCD_DTP_FK_equivalent_is_not_trusted    bit;

    DECLARE @CSTCD_DTP_FK_conflict_parent              nvarchar(517);


    SET @CSTCD_DTP_FK_expected_name = N'FK_CSTCD_DTP';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'customer.CustomerDocumentType', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.CustomerDocumentType';

        ;THROW 50576,
            N'Foreign key FK_CSTCD_DTP cannot be deployed because customer.CustomerDocumentType does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerDocument', N'CSTCD_DTP_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CSTCD_DTP_id';

        ;THROW 50577,
            N'Foreign key FK_CSTCD_DTP cannot be deployed because CSTCD_DTP_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerDocumentType', N'DTP_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : DTP_id';

        ;THROW 50578,
            N'Foreign key FK_CSTCD_DTP cannot be deployed because referenced column customer.CustomerDocumentType.DTP_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CSTCD_DTP_id -> smallint NOT NULL
            DTP_id       -> smallint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'customer.CustomerDocumentType')

        WHERE parent_column.object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND parent_column.name =
                N'CSTCD_DTP_id'

        AND referenced_column.name =
                N'DTP_id'

        AND parent_column.system_type_id =
                referenced_column.system_type_id

        AND parent_column.max_length =
                referenced_column.max_length

        AND parent_column.precision =
                referenced_column.precision

        AND parent_column.scale =
                referenced_column.scale

        AND TYPE_NAME(parent_column.user_type_id) =
                N'smallint'

        AND TYPE_NAME(referenced_column.user_type_id) =
                N'smallint'
    )
    BEGIN

        PRINT N'        [X] Foreign key column mismatch    : CSTCD_DTP_id -> DTP_id';

        ;THROW 50579,
            N'Foreign key FK_CSTCD_DTP cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_CSTCD_DTP';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @CSTCD_DTP_FK_actual_name =
            fk.name,

        @CSTCD_DTP_FK_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @CSTCD_DTP_FK_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @CSTCD_DTP_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CSTCD_DTP_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CSTCD_DTP_FK_actual_is_disabled =
            fk.is_disabled,

        @CSTCD_DTP_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CSTCD_DTP_FK_actual_parent_columns =
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

        @CSTCD_DTP_FK_actual_referenced_columns =
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
            OBJECT_ID(N'customer.CustomerDocument')

    AND fk.name =
            @CSTCD_DTP_FK_expected_name;


    IF @CSTCD_DTP_FK_actual_name IS NOT NULL
    BEGIN

        IF @CSTCD_DTP_FK_actual_parent_table =
                N'[customer].[CustomerDocument]'

        AND @CSTCD_DTP_FK_actual_parent_columns =
                N'CSTCD_DTP_id'

        AND @CSTCD_DTP_FK_actual_referenced_table =
                N'[customer].[CustomerDocumentType]'

        AND @CSTCD_DTP_FK_actual_referenced_columns =
                N'DTP_id'

        AND @CSTCD_DTP_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CSTCD_DTP_FK_actual_update_action =
                N'NO_ACTION'

        AND @CSTCD_DTP_FK_actual_is_disabled = 0

        AND @CSTCD_DTP_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CSTCD_DTP';
            PRINT N'            Column                          : CSTCD_DTP_id';
            PRINT N'            References                      : customer.CustomerDocumentType.DTP_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CSTCD_DTP';
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END
    ELSE
    BEGIN

        SELECT TOP (1)

            @CSTCD_DTP_FK_equivalent_name =
                fk.name,

            @CSTCD_DTP_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CSTCD_DTP_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CSTCD_DTP_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CSTCD_DTP_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.CustomerDocument')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND fk.name <>
                @CSTCD_DTP_FK_expected_name

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
                ON pc.object_id = fkc.parent_object_id
                AND pc.column_id = fkc.parent_column_id

            INNER JOIN sys.columns AS rc
                ON rc.object_id = fkc.referenced_object_id
                AND rc.column_id = fkc.referenced_column_id

            WHERE fkc.constraint_object_id =
                    fk.object_id

            AND fkc.constraint_column_id = 1

            AND pc.name =
                    N'CSTCD_DTP_id'

            AND rc.name =
                    N'DTP_id'
        )

        ORDER BY fk.name;


        IF @CSTCD_DTP_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';
            PRINT N'            Expected Name                  : FK_CSTCD_DTP';
            PRINT N'            Actual Name                    : '
                + @CSTCD_DTP_FK_equivalent_name;
            PRINT N'            Column                         : CSTCD_DTP_id';
            PRINT N'            References                     : customer.CustomerDocumentType.DTP_id';
            PRINT N'            Existing constraint was preserved for review.';

        END
        ELSE
        BEGIN

            IF OBJECT_ID(N'customer.FK_CSTCD_DTP', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CSTCD_DTP_FK_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'customer.FK_CSTCD_DTP', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_CSTCD_DTP';
                PRINT N'            Expected Table                  : customer.CustomerDocument';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@CSTCD_DTP_FK_conflict_parent, N'<UNKNOWN>');
                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50580,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            ALTER TABLE customer.CustomerDocument
                WITH CHECK
                ADD CONSTRAINT FK_CSTCD_DTP
                FOREIGN KEY
                (
                    CSTCD_DTP_id
                )
                REFERENCES customer.CustomerDocumentType
                (
                    DTP_id
                );


            ALTER TABLE customer.CustomerDocument
                CHECK CONSTRAINT FK_CSTCD_DTP;


            PRINT N'        [+] Foreign key constraint added    : FK_CSTCD_DTP';
            PRINT N'            Column                          : CSTCD_DTP_id';
            PRINT N'            References                      : customer.CustomerDocumentType.DTP_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';