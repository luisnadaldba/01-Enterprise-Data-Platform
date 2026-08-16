PRINT N'    customer.CustomerType';
PRINT N'    --------------------------------------------------------------------------';


/*==============================================================================
    DEFAULT CONSTRAINT: DF_CSTCT_created_at
==============================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON c.object_id = dc.parent_object_id
    AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerType')
    AND c.name = N'CSTCT_created_at'
)
BEGIN

    ALTER TABLE customer.CustomerType
        ADD CONSTRAINT DF_CSTCT_created_at
        DEFAULT (SYSDATETIME()) FOR CSTCT_created_at;

    PRINT N'        [+] Default constraint added      : DF_CSTCT_created_at';
    PRINT N'            Column                        : CSTCT_created_at';
    PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

END
ELSE
BEGIN

    DECLARE
        @CSTCT_created_at_constraint_name sysname,
        @CSTCT_created_at_definition      nvarchar(4000);


    SELECT
        @CSTCT_created_at_constraint_name = dc.name,
        @CSTCT_created_at_definition      = dc.definition

    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON c.object_id = dc.parent_object_id
    AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerType')
    AND c.name = N'CSTCT_created_at';


    IF @CSTCT_created_at_constraint_name = N'DF_CSTCT_created_at'
    AND UPPER(REPLACE(REPLACE(@CSTCT_created_at_definition, N'(', N''), N')', N''))
        = N'SYSDATETIME'
    BEGIN

        PRINT N'        [•] Default constraint validated  : DF_CSTCT_created_at';
        PRINT N'            Column                        : CSTCT_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        PRINT N'        [!] Default constraint mismatch   : DF_CSTCT_created_at';
        PRINT N'            Expected Name                 : DF_CSTCT_created_at';
        PRINT N'            Actual Name                   : '
            + COALESCE(@CSTCT_created_at_constraint_name, N'<NULL>');
        PRINT N'            Column                        : CSTCT_created_at';
        PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
        PRINT N'            Actual Definition             : DEFAULT '
            + COALESCE(@CSTCT_created_at_definition, N'<NULL>');
        PRINT N'            Existing constraint was preserved for review.';

    END;

END;


/*==============================================================================
    DEFAULT CONSTRAINT: DF_CSTCT_updated_at
==============================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON c.object_id = dc.parent_object_id
    AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerType')
    AND c.name = N'CSTCT_updated_at'
)
BEGIN

    ALTER TABLE customer.CustomerType
        ADD CONSTRAINT DF_CSTCT_updated_at
        DEFAULT (SYSDATETIME()) FOR CSTCT_updated_at;

    PRINT N'        [+] Default constraint added      : DF_CSTCT_updated_at';
    PRINT N'            Column                        : CSTCT_updated_at';
    PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

END
ELSE
BEGIN

    DECLARE
        @CSTCT_updated_at_constraint_name sysname,
        @CSTCT_updated_at_definition      nvarchar(4000);


    SELECT
        @CSTCT_updated_at_constraint_name = dc.name,
        @CSTCT_updated_at_definition      = dc.definition

    FROM sys.default_constraints AS dc

    INNER JOIN sys.columns AS c
        ON c.object_id = dc.parent_object_id
    AND c.column_id = dc.parent_column_id

    WHERE dc.parent_object_id = OBJECT_ID(N'customer.CustomerType')
    AND c.name = N'CSTCT_updated_at';


    IF @CSTCT_updated_at_constraint_name = N'DF_CSTCT_updated_at'
    AND UPPER(REPLACE(REPLACE(@CSTCT_updated_at_definition, N'(', N''), N')', N''))
        = N'SYSDATETIME'
    BEGIN

        PRINT N'        [•] Default constraint validated  : DF_CSTCT_updated_at';
        PRINT N'            Column                        : CSTCT_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        PRINT N'        [!] Default constraint mismatch   : DF_CSTCT_updated_at';
        PRINT N'            Expected Name                 : DF_CSTCT_updated_at';
        PRINT N'            Actual Name                   : '
            + COALESCE(@CSTCT_updated_at_constraint_name, N'<NULL>');
        PRINT N'            Column                        : CSTCT_updated_at';
        PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';
        PRINT N'            Actual Definition             : DEFAULT '
            + COALESCE(@CSTCT_updated_at_definition, N'<NULL>');
        PRINT N'            Existing constraint was preserved for review.';

    END;

END;


PRINT N'';