    PRINT N'';
    PRINT N'    ● reference.Address';
    PRINT N'';


    /*==========================================================================
        EXPECTED CHECK CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @ADR_expected_checks TABLE
    (
        ADR_ck_id                   tinyint IDENTITY(1,1) NOT NULL,
        ADR_ck_name                 sysname               NOT NULL,
        ADR_column_name             sysname               NOT NULL,
        ADR_expected_definition     nvarchar(4000)         NOT NULL,
        ADR_protected_literal       nvarchar(4000)         NULL
    );


    /*
        ADR_protected_literal is used when part of the CHECK expression is
        case-sensitive or contains syntax that must not be altered during
        normalization.

        The normalization engine temporarily replaces that literal with a
        neutral token before normalizing SQL syntax. This prevents meaningful
        LIKE pattern characters such as [ and ] from being removed.
    */


    /*--------------------------------------------------------------------------
        CK_ADR_postal_code

        Rule:
            Postal code must contain exactly eight numeric digits.

        The LIKE pattern contains square brackets with semantic meaning, so the
        literal is protected before normalization.

        The expression intentionally uses NOT (...) LIKE semantics because
        SQL Server persists NOT LIKE expressions with NOT preceding the
        evaluated expression in sys.check_constraints.definition.
    --------------------------------------------------------------------------*/

    INSERT INTO @ADR_expected_checks
    (
        ADR_ck_name,
        ADR_column_name,
        ADR_expected_definition,
        ADR_protected_literal
    )
    VALUES
    (
        N'CK_ADR_postal_code',
        N'ADR_postal_code',
        N'LEN(ADR_postal_code) = 8 AND NOT (ADR_postal_code LIKE ''%[^0-9]%'')',
        N'''%[^0-9]%'''
    );


    /*==========================================================================
        CHECK CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @ADR_ck_current_id                     tinyint;
    DECLARE @ADR_ck_max_id                         tinyint;

    DECLARE @ADR_ck_expected_name                  sysname;
    DECLARE @ADR_ck_column_name                    sysname;
    DECLARE @ADR_ck_expected_definition            nvarchar(4000);
    DECLARE @ADR_ck_protected_literal              nvarchar(4000);

    DECLARE @ADR_ck_expected_working_definition    nvarchar(4000);
    DECLARE @ADR_ck_expected_signature             nvarchar(4000);

    DECLARE @ADR_ck_actual_name                    sysname;
    DECLARE @ADR_ck_actual_definition              nvarchar(4000);
    DECLARE @ADR_ck_actual_working_definition      nvarchar(4000);
    DECLARE @ADR_ck_actual_signature               nvarchar(4000);
    DECLARE @ADR_ck_actual_is_disabled             bit;
    DECLARE @ADR_ck_actual_is_not_trusted          bit;

    DECLARE @ADR_ck_equivalent_name                sysname;
    DECLARE @ADR_ck_equivalent_definition          nvarchar(4000);
    DECLARE @ADR_ck_equivalent_is_disabled         bit;
    DECLARE @ADR_ck_equivalent_is_not_trusted      bit;

    DECLARE @ADR_ck_parent_object                  nvarchar(517);
    DECLARE @ADR_ck_qualified_name                 nvarchar(517);

    DECLARE @ADR_ck_sql                            nvarchar(max);


    SELECT
        @ADR_ck_current_id = MIN(ADR_ck_id),
        @ADR_ck_max_id     = MAX(ADR_ck_id)
    FROM @ADR_expected_checks;


    WHILE @ADR_ck_current_id <= @ADR_ck_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT CHECK STATE
        ----------------------------------------------------------------------*/

        SET @ADR_ck_expected_name                 = NULL;
        SET @ADR_ck_column_name                   = NULL;
        SET @ADR_ck_expected_definition           = NULL;
        SET @ADR_ck_protected_literal             = NULL;

        SET @ADR_ck_expected_working_definition   = NULL;
        SET @ADR_ck_expected_signature            = NULL;

        SET @ADR_ck_actual_name                   = NULL;
        SET @ADR_ck_actual_definition             = NULL;
        SET @ADR_ck_actual_working_definition     = NULL;
        SET @ADR_ck_actual_signature              = NULL;
        SET @ADR_ck_actual_is_disabled            = NULL;
        SET @ADR_ck_actual_is_not_trusted         = NULL;

        SET @ADR_ck_equivalent_name               = NULL;
        SET @ADR_ck_equivalent_definition         = NULL;
        SET @ADR_ck_equivalent_is_disabled        = NULL;
        SET @ADR_ck_equivalent_is_not_trusted     = NULL;

        SET @ADR_ck_parent_object                 = NULL;
        SET @ADR_ck_qualified_name                = NULL;
        SET @ADR_ck_sql                           = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @ADR_ck_expected_name =
                ADR_ck_name,

            @ADR_ck_column_name =
                ADR_column_name,

            @ADR_ck_expected_definition =
                ADR_expected_definition,

            @ADR_ck_protected_literal =
                ADR_protected_literal

        FROM @ADR_expected_checks
        WHERE ADR_ck_id = @ADR_ck_current_id;


        /*----------------------------------------------------------------------
            BUILD EXPECTED CANONICAL SIGNATURE
        ----------------------------------------------------------------------*/

        SET @ADR_ck_expected_working_definition =
            @ADR_ck_expected_definition;


        /*
            Protect literals that contain semantic square brackets before
            normalizing SQL syntax.
        */

        IF @ADR_ck_protected_literal IS NOT NULL
        BEGIN
            SET @ADR_ck_expected_working_definition =
                REPLACE
                (
                    @ADR_ck_expected_working_definition,
                    @ADR_ck_protected_literal,
                    N'__ATLAS_PROTECTED_LITERAL__'
                );
        END;


        /*
            Remove identifier brackets only from the managed column.

            Do not remove square brackets globally because the postal-code
            LIKE pattern uses them as meaningful pattern syntax.
        */

        SET @ADR_ck_expected_working_definition =
            REPLACE
            (
                @ADR_ck_expected_working_definition,
                N'[' + @ADR_ck_column_name + N']',
                @ADR_ck_column_name
            );


        /*
            Normalize non-semantic SQL formatting differences.
        */

        SET @ADR_ck_expected_signature =
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
                                REPLACE
                                (
                                    REPLACE
                                    (
                                        @ADR_ck_expected_working_definition,
                                        N' ',
                                        N''
                                    ),
                                    NCHAR(9),
                                    N''
                                ),
                                NCHAR(13),
                                N''
                            ),
                            NCHAR(10),
                            N''
                        ),
                        N'(',
                        N''
                    ),
                    N')',
                    N''
                )
            );


        /*----------------------------------------------------------------------
            LOOK FOR THE EXPECTED CONSTRAINT NAME
        ----------------------------------------------------------------------*/

        SELECT
            @ADR_ck_actual_name =
                cc.name,

            @ADR_ck_actual_definition =
                cc.definition,

            @ADR_ck_actual_is_disabled =
                cc.is_disabled,

            @ADR_ck_actual_is_not_trusted =
                cc.is_not_trusted

        FROM sys.check_constraints AS cc
        WHERE cc.parent_object_id =
                OBJECT_ID(N'reference.Address')
          AND cc.name =
                @ADR_ck_expected_name;


        /*======================================================================
            EXPECTED CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @ADR_ck_actual_name IS NOT NULL
        BEGIN

            /*------------------------------------------------------------------
                BUILD ACTUAL CANONICAL SIGNATURE
            ------------------------------------------------------------------*/

            SET @ADR_ck_actual_working_definition =
                @ADR_ck_actual_definition;


            IF @ADR_ck_protected_literal IS NOT NULL
            BEGIN
                SET @ADR_ck_actual_working_definition =
                    REPLACE
                    (
                        @ADR_ck_actual_working_definition,
                        @ADR_ck_protected_literal,
                        N'__ATLAS_PROTECTED_LITERAL__'
                    );
            END;


            SET @ADR_ck_actual_working_definition =
                REPLACE
                (
                    @ADR_ck_actual_working_definition,
                    N'[' + @ADR_ck_column_name + N']',
                    @ADR_ck_column_name
                );


            SET @ADR_ck_actual_signature =
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
                                    REPLACE
                                    (
                                        REPLACE
                                        (
                                            @ADR_ck_actual_working_definition,
                                            N' ',
                                            N''
                                        ),
                                        NCHAR(9),
                                        N''
                                    ),
                                    NCHAR(13),
                                    N''
                                ),
                                NCHAR(10),
                                N''
                            ),
                            N'(',
                            N''
                        ),
                        N')',
                        N''
                    )
                );


            /*------------------------------------------------------------------
                EXPECTED CONSTRAINT EXISTS AND MATCHES
            ------------------------------------------------------------------*/

            IF @ADR_ck_actual_signature COLLATE Latin1_General_100_BIN2
                    =
               @ADR_ck_expected_signature COLLATE Latin1_General_100_BIN2

               AND @ADR_ck_actual_is_disabled = 0
               AND @ADR_ck_actual_is_not_trusted = 0
            BEGIN

                PRINT N'        [•] Check constraint validated     : '
                    + @ADR_ck_expected_name;

                PRINT N'            Column                         : '
                    + @ADR_ck_column_name;

                PRINT N'            Definition                     : CHECK ('
                    + @ADR_ck_expected_definition
                    + N')';

            END

            ELSE
            BEGIN

                PRINT N'        [!] Check constraint mismatch      : '
                    + @ADR_ck_expected_name;

                PRINT N'            Expected Name                  : '
                    + @ADR_ck_expected_name;

                PRINT N'            Actual Name                    : '
                    + COALESCE
                      (
                          @ADR_ck_actual_name,
                          N'<NULL>'
                      );

                PRINT N'            Expected Definition            : CHECK ('
                    + @ADR_ck_expected_definition
                    + N')';

                PRINT N'            Actual Definition              : '
                    + COALESCE
                      (
                          @ADR_ck_actual_definition,
                          N'<NULL>'
                      );

                PRINT N'            Expected Disabled              : 0';

                PRINT N'            Actual Disabled                : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @ADR_ck_actual_is_disabled
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Expected Not Trusted           : 0';

                PRINT N'            Actual Not Trusted             : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @ADR_ck_actual_is_not_trusted
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Existing constraint was preserved for review.';

            END;

        END

        /*======================================================================
            EXPECTED CONSTRAINT NAME DOES NOT EXIST
        ======================================================================*/

        ELSE
        BEGIN

            /*------------------------------------------------------------------
                SEARCH FOR FUNCTIONALLY EQUIVALENT CONSTRAINT WITH OTHER NAME
            ------------------------------------------------------------------*/

            SELECT TOP (1)

                @ADR_ck_equivalent_name =
                    cc.name,

                @ADR_ck_equivalent_definition =
                    cc.definition,

                @ADR_ck_equivalent_is_disabled =
                    cc.is_disabled,

                @ADR_ck_equivalent_is_not_trusted =
                    cc.is_not_trusted

            FROM sys.check_constraints AS cc

            CROSS APPLY
            (
                SELECT
                    CASE
                        WHEN @ADR_ck_protected_literal IS NOT NULL
                        THEN
                            REPLACE
                            (
                                cc.definition,
                                @ADR_ck_protected_literal,
                                N'__ATLAS_PROTECTED_LITERAL__'
                            )
                        ELSE
                            cc.definition
                    END AS protected_definition
            ) AS pd

            CROSS APPLY
            (
                SELECT
                    REPLACE
                    (
                        pd.protected_definition,
                        N'[' + @ADR_ck_column_name + N']',
                        @ADR_ck_column_name
                    ) AS identifier_normalized_definition
            ) AS idn

            CROSS APPLY
            (
                SELECT
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
                                        REPLACE
                                        (
                                            REPLACE
                                            (
                                                idn.identifier_normalized_definition,
                                                N' ',
                                                N''
                                            ),
                                            NCHAR(9),
                                            N''
                                        ),
                                        NCHAR(13),
                                        N''
                                    ),
                                    NCHAR(10),
                                    N''
                                ),
                                N'(',
                                N''
                            ),
                            N')',
                            N''
                        )
                    ) AS definition_signature
            ) AS ds

            WHERE cc.parent_object_id =
                    OBJECT_ID(N'reference.Address')

              AND cc.name <>
                    @ADR_ck_expected_name

              AND ds.definition_signature COLLATE Latin1_General_100_BIN2
                    =
                  @ADR_ck_expected_signature COLLATE Latin1_General_100_BIN2

            ORDER BY
                cc.name;


            /*------------------------------------------------------------------
                EQUIVALENT CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @ADR_ck_equivalent_name IS NOT NULL
            BEGIN

                PRINT N'        [!] Check constraint naming mismatch: '
                    + @ADR_ck_column_name;

                PRINT N'            Expected Name                  : '
                    + @ADR_ck_expected_name;

                PRINT N'            Actual Name                    : '
                    + @ADR_ck_equivalent_name;

                PRINT N'            Expected Definition            : CHECK ('
                    + @ADR_ck_expected_definition
                    + N')';

                PRINT N'            Actual Definition              : '
                    + COALESCE
                      (
                          @ADR_ck_equivalent_definition,
                          N'<NULL>'
                      );

                PRINT N'            Expected Disabled              : 0';

                PRINT N'            Actual Disabled                : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @ADR_ck_equivalent_is_disabled
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Expected Not Trusted           : 0';

                PRINT N'            Actual Not Trusted             : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @ADR_ck_equivalent_is_not_trusted
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Existing constraint was preserved for review.';

            END

            ELSE
            BEGIN

                /*--------------------------------------------------------------
                    VALIDATE THAT EXPECTED NAME IS NOT USED BY ANOTHER OBJECT
                --------------------------------------------------------------*/

                SET @ADR_ck_qualified_name =
                    N'reference.'
                    + @ADR_ck_expected_name;


                IF OBJECT_ID
                   (
                       @ADR_ck_qualified_name,
                       N'C'
                   ) IS NOT NULL
                BEGIN

                    SELECT
                        @ADR_ck_parent_object =
                            QUOTENAME
                            (
                                OBJECT_SCHEMA_NAME
                                (
                                    cc.parent_object_id
                                )
                            )
                            + N'.'
                            + QUOTENAME
                              (
                                  OBJECT_NAME
                                  (
                                      cc.parent_object_id
                                  )
                              )

                    FROM sys.check_constraints AS cc

                    WHERE cc.object_id =
                        OBJECT_ID
                        (
                            @ADR_ck_qualified_name,
                            N'C'
                        );


                    PRINT N'        [!] Check constraint name conflict : '
                        + @ADR_ck_expected_name;

                    PRINT N'            Expected Table                : reference.Address';

                    PRINT N'            Expected Column               : '
                        + @ADR_ck_column_name;

                    PRINT N'            Existing Parent               : '
                        + COALESCE
                          (
                              @ADR_ck_parent_object,
                              N'<UNKNOWN>'
                          );

                    PRINT N'            Constraint was not created. Manual review is required.';


                    ;THROW 50050,
                        N'Check constraint name conflict prevents safe deployment.',
                        1;

                END;


                /*--------------------------------------------------------------
                    CREATE EXPECTED CONSTRAINT
                --------------------------------------------------------------*/

                SET @ADR_ck_sql =
                    N'ALTER TABLE reference.Address
                        WITH CHECK
                        ADD CONSTRAINT '
                    + QUOTENAME(@ADR_ck_expected_name)
                    + N'
                        CHECK
                        (
                            '
                    + @ADR_ck_expected_definition
                    + N'
                        );

                      ALTER TABLE reference.Address
                        CHECK CONSTRAINT '
                    + QUOTENAME(@ADR_ck_expected_name)
                    + N';';


                EXEC sys.sp_executesql
                    @ADR_ck_sql;


                PRINT N'        [+] Check constraint added         : '
                    + @ADR_ck_expected_name;

                PRINT N'            Column                         : '
                    + @ADR_ck_column_name;

                PRINT N'            Definition                     : CHECK ('
                    + @ADR_ck_expected_definition
                    + N')';

            END;

        END;


        SET @ADR_ck_current_id =
            @ADR_ck_current_id + 1;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';