    PRINT N'';
    PRINT N'    ● catalog.ProductVariantPrice';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PRDVP_created_at
    ==============================================================================*/

    IF NOT EXISTS
    (
        SELECT 1

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND c.name =
                N'PRDVP_created_at'
    )
    BEGIN

        ALTER TABLE catalog.ProductVariantPrice
            ADD CONSTRAINT DF_PRDVP_created_at
            DEFAULT (SYSDATETIME()) FOR PRDVP_created_at;


        PRINT N'        [+] Default constraint added      : DF_PRDVP_created_at';
        PRINT N'            Column                        : PRDVP_created_at';
        PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

    END
    ELSE
    BEGIN

        DECLARE
            @PRDVP_created_at_constraint_name sysname,
            @PRDVP_created_at_definition      nvarchar(4000);


        SELECT
            @PRDVP_created_at_constraint_name =
                dc.name,

            @PRDVP_created_at_definition =
                dc.definition

        FROM sys.default_constraints AS dc

        INNER JOIN sys.columns AS c
            ON  c.object_id = dc.parent_object_id
            AND c.column_id = dc.parent_column_id

        WHERE dc.parent_object_id =
                OBJECT_ID(N'catalog.ProductVariantPrice')

        AND c.name =
                N'PRDVP_created_at';


        IF @PRDVP_created_at_constraint_name =
                N'DF_PRDVP_created_at'

        AND UPPER
            (
                REPLACE
                (
                    REPLACE
                    (
                        @PRDVP_created_at_definition,
                        N'(',
                        N''
                    ),
                    N')',
                    N''
                )
            ) = N'SYSDATETIME'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PRDVP_created_at';
            PRINT N'            Column                        : PRDVP_created_at';
            PRINT N'            Definition                    : DEFAULT (SYSDATETIME())';

        END
        ELSE
        BEGIN

            PRINT N'        [!] Default constraint mismatch   : DF_PRDVP_created_at';

            PRINT N'            Expected Name                 : DF_PRDVP_created_at';

            PRINT N'            Actual Name                   : '
                + COALESCE
                (
                    @PRDVP_created_at_constraint_name,
                    N'<NULL>'
                );

            PRINT N'            Column                        : PRDVP_created_at';

            PRINT N'            Expected Definition           : DEFAULT (SYSDATETIME())';

            PRINT N'            Actual Definition             : DEFAULT '
                + COALESCE
                (
                    @PRDVP_created_at_definition,
                    N'<NULL>'
                );

            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';