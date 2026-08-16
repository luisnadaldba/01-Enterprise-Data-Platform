    PRINT N'    customer.Customer';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        FOREIGN KEY: FK_CST_CSTCT
    ==============================================================================*/

    DECLARE @CST_CSTCT_FK_expected_name                sysname;
    DECLARE @CST_CSTCT_FK_actual_name                  sysname;

    DECLARE @CST_CSTCT_FK_actual_parent_table          nvarchar(517);
    DECLARE @CST_CSTCT_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CST_CSTCT_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CST_CSTCT_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CST_CSTCT_FK_actual_delete_action         nvarchar(60);
    DECLARE @CST_CSTCT_FK_actual_update_action         nvarchar(60);

    DECLARE @CST_CSTCT_FK_actual_is_disabled           bit;
    DECLARE @CST_CSTCT_FK_actual_is_not_trusted        bit;

    DECLARE @CST_CSTCT_FK_equivalent_name              sysname;
    DECLARE @CST_CSTCT_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CST_CSTCT_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CST_CSTCT_FK_equivalent_is_disabled       bit;
    DECLARE @CST_CSTCT_FK_equivalent_is_not_trusted    bit;

    DECLARE @CST_CSTCT_FK_conflict_parent              nvarchar(517);


    SET @CST_CSTCT_FK_expected_name = N'FK_CST_CSTCT';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'customer.Customer', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.Customer';

        ;THROW 50370,
            N'Foreign key FK_CST_CSTCT cannot be deployed because customer.Customer does not exist.',
            1;

    END;


    IF OBJECT_ID(N'customer.CustomerType', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : customer.CustomerType';

        ;THROW 50371,
            N'Foreign key FK_CST_CSTCT cannot be deployed because customer.CustomerType does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.Customer', N'CST_CSTCT_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CST_CSTCT_id';

        ;THROW 50372,
            N'Foreign key FK_CST_CSTCT cannot be deployed because CST_CSTCT_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.CustomerType', N'CSTCT_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : CSTCT_id';

        ;THROW 50373,
            N'Foreign key FK_CST_CSTCT cannot be deployed because referenced column customer.CustomerType.CSTCT_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CST_CSTCT_id -> smallint NOT NULL
            CSTCT_id     -> smallint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'customer.CustomerType')

        WHERE parent_column.object_id =
                OBJECT_ID(N'customer.Customer')

        AND parent_column.name =
                N'CST_CSTCT_id'

        AND referenced_column.name =
                N'CSTCT_id'

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

        PRINT N'        [X] Foreign key column mismatch    : CST_CSTCT_id -> CSTCT_id';

        ;THROW 50374,
            N'Foreign key FK_CST_CSTCT cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_CST_CSTCT';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @CST_CSTCT_FK_actual_name =
            fk.name,

        @CST_CSTCT_FK_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @CST_CSTCT_FK_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @CST_CSTCT_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CST_CSTCT_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CST_CSTCT_FK_actual_is_disabled =
            fk.is_disabled,

        @CST_CSTCT_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CST_CSTCT_FK_actual_parent_columns =
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

        @CST_CSTCT_FK_actual_referenced_columns =
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
            OBJECT_ID(N'customer.Customer')

    AND fk.name =
            @CST_CSTCT_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @CST_CSTCT_FK_actual_name IS NOT NULL
    BEGIN

        IF @CST_CSTCT_FK_actual_parent_table =
                N'[customer].[Customer]'

        AND @CST_CSTCT_FK_actual_parent_columns =
                N'CST_CSTCT_id'

        AND @CST_CSTCT_FK_actual_referenced_table =
                N'[customer].[CustomerType]'

        AND @CST_CSTCT_FK_actual_referenced_columns =
                N'CSTCT_id'

        AND @CST_CSTCT_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CST_CSTCT_FK_actual_update_action =
                N'NO_ACTION'

        AND @CST_CSTCT_FK_actual_is_disabled = 0

        AND @CST_CSTCT_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CST_CSTCT';
            PRINT N'            Column                          : CST_CSTCT_id';
            PRINT N'            References                      : customer.CustomerType.CSTCT_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CST_CSTCT';

            PRINT N'            Expected Table                  : customer.Customer';
            PRINT N'            Actual Table                    : '
                + COALESCE(@CST_CSTCT_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : CST_CSTCT_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CST_CSTCT_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : customer.CustomerType.CSTCT_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@CST_CSTCT_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CST_CSTCT_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@CST_CSTCT_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@CST_CSTCT_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_CSTCT_FK_actual_is_disabled),
                    N'<NULL>'
                );

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_CSTCT_FK_actual_is_not_trusted),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*==========================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==========================================================================*/

        SELECT TOP (1)

            @CST_CSTCT_FK_equivalent_name =
                fk.name,

            @CST_CSTCT_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CST_CSTCT_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CST_CSTCT_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CST_CSTCT_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.referenced_object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND fk.name <>
                @CST_CSTCT_FK_expected_name

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
                    N'CST_CSTCT_id'

            AND rc.name =
                    N'CSTCT_id'
        )

        ORDER BY fk.name;


        IF @CST_CSTCT_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_CST_CSTCT';

            PRINT N'            Actual Name                    : '
                + @CST_CSTCT_FK_equivalent_name;

            PRINT N'            Column                         : CST_CSTCT_id';

            PRINT N'            References                     : customer.CustomerType.CSTCT_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE(@CST_CSTCT_FK_equivalent_delete_action, N'<NULL>');

            PRINT N'            ON UPDATE                      : '
                + COALESCE(@CST_CSTCT_FK_equivalent_update_action, N'<NULL>');

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_CSTCT_FK_equivalent_is_disabled),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_CSTCT_FK_equivalent_is_not_trusted),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            IF OBJECT_ID(N'customer.FK_CST_CSTCT', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CST_CSTCT_FK_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'customer.FK_CST_CSTCT', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_CST_CSTCT';
                PRINT N'            Expected Table                  : customer.Customer';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@CST_CSTCT_FK_conflict_parent, N'<UNKNOWN>');

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50375,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            ALTER TABLE customer.Customer
                WITH CHECK
                ADD CONSTRAINT FK_CST_CSTCT
                FOREIGN KEY
                (
                    CST_CSTCT_id
                )
                REFERENCES customer.CustomerType
                (
                    CSTCT_id
                );


            ALTER TABLE customer.Customer
                CHECK CONSTRAINT FK_CST_CSTCT;


            PRINT N'        [+] Foreign key constraint added    : FK_CST_CSTCT';
            PRINT N'            Column                          : CST_CSTCT_id';
            PRINT N'            References                      : customer.CustomerType.CSTCT_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    /*==============================================================================
        FOREIGN KEY: FK_CST_STS
    ==============================================================================*/

    DECLARE @CST_STS_FK_expected_name                sysname;
    DECLARE @CST_STS_FK_actual_name                  sysname;

    DECLARE @CST_STS_FK_actual_parent_table          nvarchar(517);
    DECLARE @CST_STS_FK_actual_parent_columns        nvarchar(4000);

    DECLARE @CST_STS_FK_actual_referenced_table      nvarchar(517);
    DECLARE @CST_STS_FK_actual_referenced_columns    nvarchar(4000);

    DECLARE @CST_STS_FK_actual_delete_action         nvarchar(60);
    DECLARE @CST_STS_FK_actual_update_action         nvarchar(60);

    DECLARE @CST_STS_FK_actual_is_disabled           bit;
    DECLARE @CST_STS_FK_actual_is_not_trusted        bit;

    DECLARE @CST_STS_FK_equivalent_name              sysname;
    DECLARE @CST_STS_FK_equivalent_delete_action     nvarchar(60);
    DECLARE @CST_STS_FK_equivalent_update_action     nvarchar(60);
    DECLARE @CST_STS_FK_equivalent_is_disabled       bit;
    DECLARE @CST_STS_FK_equivalent_is_not_trusted    bit;

    DECLARE @CST_STS_FK_conflict_parent              nvarchar(517);


    SET @CST_STS_FK_expected_name = N'FK_CST_STS';


    /*==============================================================================
        DEPENDENCY VALIDATION
    ==============================================================================*/

    IF OBJECT_ID(N'reference.Status', N'U') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key dependency missing : reference.Status';

        ;THROW 50376,
            N'Foreign key FK_CST_STS cannot be deployed because reference.Status does not exist.',
            1;

    END;


    IF COL_LENGTH(N'customer.Customer', N'CST_STS_id') IS NULL
    BEGIN

        PRINT N'        [X] Foreign key column missing     : CST_STS_id';

        ;THROW 50377,
            N'Foreign key FK_CST_STS cannot be deployed because CST_STS_id does not exist.',
            1;

    END;


    IF COL_LENGTH(N'reference.Status', N'STS_id') IS NULL
    BEGIN

        PRINT N'        [X] Referenced column missing      : STS_id';

        ;THROW 50378,
            N'Foreign key FK_CST_STS cannot be deployed because referenced column reference.Status.STS_id does not exist.',
            1;

    END;


    /*--------------------------------------------------------------------------
        VALIDATE COLUMN COMPATIBILITY

        Expected:
            CST_STS_id -> tinyint NOT NULL
            STS_id     -> tinyint NOT NULL
    --------------------------------------------------------------------------*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.columns AS parent_column

        INNER JOIN sys.columns AS referenced_column
            ON referenced_column.object_id =
                    OBJECT_ID(N'reference.Status')

        WHERE parent_column.object_id =
                OBJECT_ID(N'customer.Customer')

        AND parent_column.name =
                N'CST_STS_id'

        AND referenced_column.name =
                N'STS_id'

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

        PRINT N'        [X] Foreign key column mismatch    : CST_STS_id -> STS_id';

        ;THROW 50379,
            N'Foreign key FK_CST_STS cannot be deployed because participating columns are incompatible.',
            1;

    END;


    PRINT N'        [✓] Foreign key dependencies validated : FK_CST_STS';


    /*==============================================================================
        LOOK FOR EXPECTED FOREIGN KEY NAME
    ==============================================================================*/

    SELECT
        @CST_STS_FK_actual_name =
            fk.name,

        @CST_STS_FK_actual_parent_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.parent_object_id)),

        @CST_STS_FK_actual_referenced_table =
            QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id))
            + N'.'
            + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)),

        @CST_STS_FK_actual_delete_action =
            fk.delete_referential_action_desc,

        @CST_STS_FK_actual_update_action =
            fk.update_referential_action_desc,

        @CST_STS_FK_actual_is_disabled =
            fk.is_disabled,

        @CST_STS_FK_actual_is_not_trusted =
            fk.is_not_trusted,

        @CST_STS_FK_actual_parent_columns =
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

        @CST_STS_FK_actual_referenced_columns =
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
            OBJECT_ID(N'customer.Customer')

    AND fk.name =
            @CST_STS_FK_expected_name;


    /*==============================================================================
        EXPECTED FOREIGN KEY NAME EXISTS
    ==============================================================================*/

    IF @CST_STS_FK_actual_name IS NOT NULL
    BEGIN

        IF @CST_STS_FK_actual_parent_table =
                N'[customer].[Customer]'

        AND @CST_STS_FK_actual_parent_columns =
                N'CST_STS_id'

        AND @CST_STS_FK_actual_referenced_table =
                N'[reference].[Status]'

        AND @CST_STS_FK_actual_referenced_columns =
                N'STS_id'

        AND @CST_STS_FK_actual_delete_action =
                N'NO_ACTION'

        AND @CST_STS_FK_actual_update_action =
                N'NO_ACTION'

        AND @CST_STS_FK_actual_is_disabled = 0

        AND @CST_STS_FK_actual_is_not_trusted = 0
        BEGIN

            PRINT N'        [•] Foreign key validated            : FK_CST_STS';
            PRINT N'            Column                          : CST_STS_id';
            PRINT N'            References                      : reference.Status.STS_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Foreign key mismatch             : FK_CST_STS';

            PRINT N'            Expected Table                  : customer.Customer';
            PRINT N'            Actual Table                    : '
                + COALESCE(@CST_STS_FK_actual_parent_table, N'<NULL>');

            PRINT N'            Expected Column                 : CST_STS_id';
            PRINT N'            Actual Column                   : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CST_STS_FK_actual_parent_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected Reference              : reference.Status.STS_id';

            PRINT N'            Actual Reference Table         : '
                + COALESCE(@CST_STS_FK_actual_referenced_table, N'<NULL>');

            PRINT N'            Actual Reference Column        : '
                + COALESCE
                (
                    REPLACE
                    (
                        @CST_STS_FK_actual_referenced_columns,
                        N'|',
                        N', '
                    ),
                    N'<NULL>'
                );

            PRINT N'            Expected ON DELETE              : NO ACTION';
            PRINT N'            Actual ON DELETE                : '
                + COALESCE(@CST_STS_FK_actual_delete_action, N'<NULL>');

            PRINT N'            Expected ON UPDATE              : NO ACTION';
            PRINT N'            Actual ON UPDATE                : '
                + COALESCE(@CST_STS_FK_actual_update_action, N'<NULL>');

            PRINT N'            Expected Disabled               : 0';
            PRINT N'            Actual Disabled                 : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_STS_FK_actual_is_disabled),
                    N'<NULL>'
                );

            PRINT N'            Expected Not Trusted            : 0';
            PRINT N'            Actual Not Trusted              : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_STS_FK_actual_is_not_trusted),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END

    ELSE
    BEGIN

        /*==========================================================================
            SEARCH FOR FUNCTIONALLY EQUIVALENT FOREIGN KEY WITH ANOTHER NAME
        ==========================================================================*/

        SELECT TOP (1)

            @CST_STS_FK_equivalent_name =
                fk.name,

            @CST_STS_FK_equivalent_delete_action =
                fk.delete_referential_action_desc,

            @CST_STS_FK_equivalent_update_action =
                fk.update_referential_action_desc,

            @CST_STS_FK_equivalent_is_disabled =
                fk.is_disabled,

            @CST_STS_FK_equivalent_is_not_trusted =
                fk.is_not_trusted

        FROM sys.foreign_keys AS fk

        WHERE fk.parent_object_id =
                OBJECT_ID(N'customer.Customer')

        AND fk.referenced_object_id =
                OBJECT_ID(N'reference.Status')

        AND fk.name <>
                @CST_STS_FK_expected_name

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
                    N'CST_STS_id'

            AND rc.name =
                    N'STS_id'
        )

        ORDER BY fk.name;


        IF @CST_STS_FK_equivalent_name IS NOT NULL
        BEGIN

            PRINT N'        [!] Foreign key naming mismatch';

            PRINT N'            Expected Name                  : FK_CST_STS';

            PRINT N'            Actual Name                    : '
                + @CST_STS_FK_equivalent_name;

            PRINT N'            Column                         : CST_STS_id';

            PRINT N'            References                     : reference.Status.STS_id';

            PRINT N'            ON DELETE                      : '
                + COALESCE(@CST_STS_FK_equivalent_delete_action, N'<NULL>');

            PRINT N'            ON UPDATE                      : '
                + COALESCE(@CST_STS_FK_equivalent_update_action, N'<NULL>');

            PRINT N'            Disabled                       : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_STS_FK_equivalent_is_disabled),
                    N'<NULL>'
                );

            PRINT N'            Not Trusted                    : '
                + COALESCE
                (
                    CONVERT(nvarchar(1), @CST_STS_FK_equivalent_is_not_trusted),
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END

        ELSE
        BEGIN

            IF OBJECT_ID(N'customer.FK_CST_STS', N'F') IS NOT NULL
            BEGIN

                SELECT
                    @CST_STS_FK_conflict_parent =
                        QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id))
                        + N'.'
                        + QUOTENAME(OBJECT_NAME(fk.parent_object_id))

                FROM sys.foreign_keys AS fk

                WHERE fk.object_id =
                        OBJECT_ID(N'customer.FK_CST_STS', N'F');


                PRINT N'        [!] Foreign key name conflict       : FK_CST_STS';
                PRINT N'            Expected Table                  : customer.Customer';
                PRINT N'            Existing Parent                 : '
                    + COALESCE(@CST_STS_FK_conflict_parent, N'<UNKNOWN>');

                PRINT N'            Constraint was not created. Manual review is required.';


                ;THROW 50380,
                    N'Foreign key name conflict prevents safe deployment.',
                    1;

            END;


            ALTER TABLE customer.Customer
                WITH CHECK
                ADD CONSTRAINT FK_CST_STS
                FOREIGN KEY
                (
                    CST_STS_id
                )
                REFERENCES reference.Status
                (
                    STS_id
                );


            ALTER TABLE customer.Customer
                CHECK CONSTRAINT FK_CST_STS;


            PRINT N'        [+] Foreign key constraint added    : FK_CST_STS';
            PRINT N'            Column                          : CST_STS_id';
            PRINT N'            References                      : reference.Status.STS_id';
            PRINT N'            ON DELETE                       : NO ACTION';
            PRINT N'            ON UPDATE                       : NO ACTION';
            PRINT N'            Enabled                         : YES';
            PRINT N'            Trusted                         : YES';

        END;

    END;


    PRINT N'';