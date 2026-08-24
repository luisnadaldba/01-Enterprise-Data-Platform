    PRINT N'';
    PRINT N'    ● metadata.TablePrefix';
    PRINT N'';


    /*==============================================================================
        DEFAULT CONSTRAINT: DF_PFX_is_active
    ==============================================================================*/

    DECLARE @PFX_default_expected_name          sysname;
    DECLARE @PFX_default_actual_name            sysname;
    DECLARE @PFX_default_actual_definition      nvarchar(4000);
    DECLARE @PFX_default_normalized_definition  nvarchar(4000);
    DECLARE @PFX_default_parent_object          nvarchar(517);

    SET @PFX_default_expected_name = N'DF_PFX_is_active';


    /*----------------------------------------------------------------------
        VALIDATE DEFAULT CURRENTLY ASSOCIATED WITH PFX_is_active
    ----------------------------------------------------------------------*/

    SELECT
        @PFX_default_actual_name = dc.name,
        @PFX_default_actual_definition = dc.definition
    FROM sys.default_constraints AS dc
    INNER JOIN sys.columns AS c
        ON  c.object_id = dc.parent_object_id
        AND c.column_id = dc.parent_column_id
    WHERE dc.parent_object_id = OBJECT_ID(N'metadata.TablePrefix')
    AND c.name = N'PFX_is_active';


    /*----------------------------------------------------------------------
        NO DEFAULT CURRENTLY EXISTS ON PFX_is_active
    ----------------------------------------------------------------------*/

    IF @PFX_default_actual_name IS NULL
    BEGIN

        /*
            Before creating the expected constraint, validate that its
            deterministic name is not already being used by another object.
        */

        IF OBJECT_ID(N'metadata.DF_PFX_is_active', N'D') IS NOT NULL
        BEGIN

            SELECT
                @PFX_default_parent_object =
                    QUOTENAME(OBJECT_SCHEMA_NAME(dc.parent_object_id))
                    + N'.'
                    + QUOTENAME(OBJECT_NAME(dc.parent_object_id))
            FROM sys.default_constraints AS dc
            WHERE dc.object_id =
                OBJECT_ID(N'metadata.DF_PFX_is_active', N'D');


            PRINT N'        [!] Default constraint name conflict : DF_PFX_is_active';
            PRINT N'            Expected Table                : metadata.TablePrefix';
            PRINT N'            Expected Column               : PFX_is_active';
            PRINT N'            Existing Parent               : '
                + COALESCE(@PFX_default_parent_object, N'<UNKNOWN>');
            PRINT N'            Constraint was not created. Manual review is required.';


            ;THROW 50002,
                N'Default constraint DF_PFX_is_active already exists on another object.',
                1;

        END;


        ALTER TABLE metadata.TablePrefix
            ADD CONSTRAINT DF_PFX_is_active
            DEFAULT (1) FOR PFX_is_active;


        PRINT N'        [+] Default constraint added      : DF_PFX_is_active';
        PRINT N'            Column                        : PFX_is_active';
        PRINT N'            Definition                    : DEFAULT (1)';

    END

    ELSE
    BEGIN

        /*
            SQL Server may persist equivalent simple default expressions with
            additional parentheses, for example ((1)). Normalize the stored
            definition before comparison to prevent false divergence warnings.
        */

        SET @PFX_default_normalized_definition =
            LOWER
            (
                REPLACE
                (
                    REPLACE
                    (
                        REPLACE
                        (
                            REPLACE
                            (
                                @PFX_default_actual_definition,
                                N'(',
                                N''
                            ),
                            N')',
                            N''
                        ),
                        N' ',
                        N''
                    ),
                    NCHAR(9),
                    N''
                )
            );


        /*------------------------------------------------------------------
            EXPECTED DEFAULT EXISTS AND MATCHES
        ------------------------------------------------------------------*/

        IF @PFX_default_actual_name = @PFX_default_expected_name
        AND @PFX_default_normalized_definition = N'1'
        BEGIN

            PRINT N'        [•] Default constraint validated  : DF_PFX_is_active';
            PRINT N'            Column                        : PFX_is_active';
            PRINT N'            Definition                    : DEFAULT (1)';

        END

        ELSE
        BEGIN

            /*--------------------------------------------------------------
                DEFAULT EXISTS BUT DIFFERS FROM EXPECTED DEFINITION
            --------------------------------------------------------------*/

            PRINT N'        [!] Default constraint mismatch   : PFX_is_active';
            PRINT N'            Expected Name                 : DF_PFX_is_active';
            PRINT N'            Actual Name                   : '
                + COALESCE(@PFX_default_actual_name, N'<NULL>');
            PRINT N'            Expected Definition           : DEFAULT (1)';
            PRINT N'            Actual Definition             : '
                + COALESCE(@PFX_default_actual_definition, N'<NULL>');
            PRINT N'            Existing constraint was preserved for review.';

        END;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';