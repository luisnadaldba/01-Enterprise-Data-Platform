    PRINT N'    reference.ContactType';
    PRINT N'    --------------------------------------------------------------------------';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTP_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.ContactType')
        AND c.name = N'CTP_created_at'
    )
    BEGIN

        ALTER TABLE reference.ContactType
            ADD CONSTRAINT DF_CTP_created_at
            DEFAULT (SYSDATETIME()) FOR CTP_created_at;

        PRINT N'        [+] Default constraint added      : DF_CTP_created_at';
        PRINT N'            Column                        : CTP_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CTP_created_at_constraint_name sysname,
            @CTP_created_at_definition      nvarchar(4000);


        SELECT
            @CTP_created_at_constraint_name = dc.name,
            @CTP_created_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.ContactType')
        AND c.name = N'CTP_created_at';


        IF @CTP_created_at_constraint_name = N'DF_CTP_created_at'
        AND UPPER(REPLACE(REPLACE(@CTP_created_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CTP_created_at';
            PRINT N'            Column                        : CTP_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CTP_created_at';
            PRINT N'            Expected Name                 : DF_CTP_created_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CTP_created_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CTP_created_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CTP_created_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_CTP_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc
        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
        WHERE dc.parent_object_id = OBJECT_ID(N'reference.ContactType')
        AND c.name = N'CTP_updated_at'
    )
    BEGIN

        ALTER TABLE reference.ContactType
            ADD CONSTRAINT DF_CTP_updated_at
            DEFAULT (SYSDATETIME()) FOR CTP_updated_at;

        PRINT N'        [+] Default constraint added      : DF_CTP_updated_at';
        PRINT N'            Column                        : CTP_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @CTP_updated_at_constraint_name sysname,
            @CTP_updated_at_definition      nvarchar(4000);


        SELECT
            @CTP_updated_at_constraint_name = dc.name,
            @CTP_updated_at_definition      = dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id = OBJECT_ID(N'reference.ContactType')
        AND c.name = N'CTP_updated_at';


        IF @CTP_updated_at_constraint_name = N'DF_CTP_updated_at'
        AND UPPER(REPLACE(REPLACE(@CTP_updated_at_definition, N'(', N''), N')', N''))
            = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_CTP_updated_at';
            PRINT N'            Column                        : CTP_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_CTP_updated_at';
            PRINT N'            Expected Name                 : DF_CTP_updated_at';
            PRINT N'            Actual Name                   : '
                + COALESCE(@CTP_updated_at_constraint_name, N'<NULL>');
            PRINT N'            Column                        : CTP_updated_at';
            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE(@CTP_updated_at_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';