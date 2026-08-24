    PRINT N'';
    PRINT N'    ● catalog.ProductImage';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRDIM_is_primary
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND c.name =
                N'PRDIM_is_primary'
    )
    BEGIN

        ALTER TABLE catalog.ProductImage
            ADD CONSTRAINT DF_PRDIM_is_primary
            DEFAULT (0) FOR PRDIM_is_primary;


        PRINT N'        [+] Default constraint added      : DF_PRDIM_is_primary';
        PRINT N'            Column                        : PRDIM_is_primary';
        PRINT N'            Definition                    : DEFAULT (0)';

    END
    ELSE
    BEGIN

        DECLARE
            @PRDIM_is_primary_constraint_name sysname,
            @PRDIM_is_primary_definition      nvarchar(4000);


        SELECT
            @PRDIM_is_primary_constraint_name =
                dc.name,

            @PRDIM_is_primary_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND c.name =
                N'PRDIM_is_primary';


        IF @PRDIM_is_primary_constraint_name =
                N'DF_PRDIM_is_primary'

        AND REPLACE
            (
                REPLACE
                (
                    @PRDIM_is_primary_definition,
                    N'(',
                    N''
                ),
                N')',
                N''
            ) = N'0'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRDIM_is_primary';
            PRINT N'            Column                        : PRDIM_is_primary';
            PRINT N'            Definition                    : DEFAULT (0)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRDIM_is_primary';

            PRINT N'            Expected Name                 : DF_PRDIM_is_primary';

            PRINT N'            Actual Name                   : '
                + COALESCE
                (
                    @PRDIM_is_primary_constraint_name,
                    N'<NULL>'
                );

            PRINT N'            Column                        : PRDIM_is_primary';

            PRINT N'            Expected Definition           : DEFAULT (0)';

            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE
                (
                    @PRDIM_is_primary_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRDIM_is_active
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND c.name =
                N'PRDIM_is_active'
    )
    BEGIN

        ALTER TABLE catalog.ProductImage
            ADD CONSTRAINT DF_PRDIM_is_active
            DEFAULT (1) FOR PRDIM_is_active;


        PRINT N'        [+] Default constraint added      : DF_PRDIM_is_active';
        PRINT N'            Column                        : PRDIM_is_active';
        PRINT N'            Definition                    : DEFAULT (1)';

    END
    ELSE
    BEGIN

        DECLARE
            @PRDIM_is_active_constraint_name sysname,
            @PRDIM_is_active_definition      nvarchar(4000);


        SELECT
            @PRDIM_is_active_constraint_name =
                dc.name,

            @PRDIM_is_active_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND c.name =
                N'PRDIM_is_active';


        IF @PRDIM_is_active_constraint_name =
                N'DF_PRDIM_is_active'

        AND REPLACE
            (
                REPLACE
                (
                    @PRDIM_is_active_definition,
                    N'(',
                    N''
                ),
                N')',
                N''
            ) = N'1'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRDIM_is_active';
            PRINT N'            Column                        : PRDIM_is_active';
            PRINT N'            Definition                    : DEFAULT (1)';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRDIM_is_active';

            PRINT N'            Expected Name                 : DF_PRDIM_is_active';

            PRINT N'            Actual Name                   : '
                + COALESCE
                (
                    @PRDIM_is_active_constraint_name,
                    N'<NULL>'
                );

            PRINT N'            Column                        : PRDIM_is_active';

            PRINT N'            Expected Definition           : DEFAULT (1)';

            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE
                (
                    @PRDIM_is_active_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRDIM_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND c.name =
                N'PRDIM_created_at'
    )
    BEGIN

        ALTER TABLE catalog.ProductImage
            ADD CONSTRAINT DF_PRDIM_created_at
            DEFAULT (SYSDATETIME()) FOR PRDIM_created_at;


        PRINT N'        [+] Default constraint added      : DF_PRDIM_created_at';
        PRINT N'            Column                        : PRDIM_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PRDIM_created_at_constraint_name sysname,
            @PRDIM_created_at_definition      nvarchar(4000);


        SELECT
            @PRDIM_created_at_constraint_name =
                dc.name,

            @PRDIM_created_at_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND c.name =
                N'PRDIM_created_at';


        IF @PRDIM_created_at_constraint_name =
                N'DF_PRDIM_created_at'

        AND UPPER
            (
                REPLACE
                (
                    REPLACE
                    (
                        @PRDIM_created_at_definition,
                        N'(',
                        N''
                    ),
                    N')',
                    N''
                )
            ) = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRDIM_created_at';
            PRINT N'            Column                        : PRDIM_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRDIM_created_at';

            PRINT N'            Expected Name                 : DF_PRDIM_created_at';

            PRINT N'            Actual Name                   : '
                + COALESCE
                (
                    @PRDIM_created_at_constraint_name,
                    N'<NULL>'
                );

            PRINT N'            Column                        : PRDIM_created_at';

            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';

            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE
                (
                    @PRDIM_created_at_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRDIM_updated_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND c.name =
                N'PRDIM_updated_at'
    )
    BEGIN

        ALTER TABLE catalog.ProductImage
            ADD CONSTRAINT DF_PRDIM_updated_at
            DEFAULT (SYSDATETIME()) FOR PRDIM_updated_at;


        PRINT N'        [+] Default constraint added      : DF_PRDIM_updated_at';
        PRINT N'            Column                        : PRDIM_updated_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PRDIM_updated_at_constraint_name sysname,
            @PRDIM_updated_at_definition      nvarchar(4000);


        SELECT
            @PRDIM_updated_at_constraint_name =
                dc.name,

            @PRDIM_updated_at_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductImage')

        AND c.name =
                N'PRDIM_updated_at';


        IF @PRDIM_updated_at_constraint_name =
                N'DF_PRDIM_updated_at'

        AND UPPER
            (
                REPLACE
                (
                    REPLACE
                    (
                        @PRDIM_updated_at_definition,
                        N'(',
                        N''
                    ),
                    N')',
                    N''
                )
            ) = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRDIM_updated_at';
            PRINT N'            Column                        : PRDIM_updated_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRDIM_updated_at';

            PRINT N'            Expected Name                 : DF_PRDIM_updated_at';

            PRINT N'            Actual Name                   : '
                + COALESCE
                (
                    @PRDIM_updated_at_constraint_name,
                    N'<NULL>'
                );

            PRINT N'            Column                        : PRDIM_updated_at';

            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';

            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE
                (
                    @PRDIM_updated_at_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';