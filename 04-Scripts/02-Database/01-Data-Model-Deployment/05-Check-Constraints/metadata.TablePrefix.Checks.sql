    PRINT N'    metadata.TablePrefix';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        EXPECTED CHECK CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @PFX_expected_checks TABLE
    (
        PFX_ck_id                   tinyint IDENTITY(1,1) NOT NULL,
        PFX_ck_name                 sysname               NOT NULL,
        PFX_column_name             sysname               NOT NULL,
        PFX_expected_definition     nvarchar(4000)         NOT NULL,
        PFX_protected_literal       nvarchar(4000)         NULL
    );


    /*
        PFX_protected_literal is used when part of the CHECK expression is
        case-sensitive by definition.

        The normalization engine temporarily replaces that literal with a
        neutral token before normalizing SQL syntax. This allows SQL keywords
        and identifiers to be compared case-insensitively without incorrectly
        treating semantically different literals as equivalent.
    */


    /*--------------------------------------------------------------------------
        CK_PFX_prefix_format

        Rule:
            Prefixes may contain only uppercase ASCII letters A through Z.

        The expression is intentionally written using NOT (...) LIKE rather
        than NOT LIKE because SQL Server persists this representation in
        sys.check_constraints.definition.
    --------------------------------------------------------------------------*/

    INSERT INTO @PFX_expected_checks
    (
        PFX_ck_name,
        PFX_column_name,
        PFX_expected_definition,
        PFX_protected_literal
    )
    VALUES
    (
        N'CK_PFX_prefix_format',
        N'PFX_prefix',
        N'NOT (PFX_prefix COLLATE Latin1_General_100_BIN2 LIKE N''%[^A-Z]%'')',
        N'N''%[^A-Z]%'''
    );


    /*--------------------------------------------------------------------------
        CK_PFX_prefix_length

        Rule:
            Prefixes must contain between 2 and 5 characters.

        Three characters remain the preferred AtlasCommerce standard.
        Two, four, and five characters are permitted according to the
        documented prefix naming rules.
    --------------------------------------------------------------------------*/

    INSERT INTO @PFX_expected_checks
    (
        PFX_ck_name,
        PFX_column_name,
        PFX_expected_definition,
        PFX_protected_literal
    )
    VALUES
    (
        N'CK_PFX_prefix_length',
        N'PFX_prefix',
        N'LEN(PFX_prefix) >= 2 AND LEN(PFX_prefix) <= 5',
        NULL
    );


    /*==========================================================================
        CHECK CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @PFX_ck_current_id                     tinyint;
    DECLARE @PFX_ck_max_id                         tinyint;

    DECLARE @PFX_ck_expected_name                  sysname;
    DECLARE @PFX_ck_column_name                    sysname;
    DECLARE @PFX_ck_expected_definition            nvarchar(4000);
    DECLARE @PFX_ck_protected_literal              nvarchar(4000);

    DECLARE @PFX_ck_expected_working_definition    nvarchar(4000);
    DECLARE @PFX_ck_expected_signature             nvarchar(4000);

    DECLARE @PFX_ck_actual_name                    sysname;
    DECLARE @PFX_ck_actual_definition              nvarchar(4000);
    DECLARE @PFX_ck_actual_working_definition      nvarchar(4000);
    DECLARE @PFX_ck_actual_signature               nvarchar(4000);
    DECLARE @PFX_ck_actual_is_disabled             bit;
    DECLARE @PFX_ck_actual_is_not_trusted          bit;

    DECLARE @PFX_ck_equivalent_name                sysname;
    DECLARE @PFX_ck_equivalent_definition          nvarchar(4000);
    DECLARE @PFX_ck_equivalent_is_disabled         bit;
    DECLARE @PFX_ck_equivalent_is_not_trusted      bit;

    DECLARE @PFX_ck_parent_object                  nvarchar(517);
    DECLARE @PFX_ck_qualified_name                 nvarchar(517);

    DECLARE @PFX_ck_sql                            nvarchar(max);


    SELECT
        @PFX_ck_current_id = MIN(PFX_ck_id),
        @PFX_ck_max_id     = MAX(PFX_ck_id)
    FROM @PFX_expected_checks;


    WHILE @PFX_ck_current_id <= @PFX_ck_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT CHECK STATE
        ----------------------------------------------------------------------*/

        SET @PFX_ck_expected_name                 = NULL;
        SET @PFX_ck_column_name                   = NULL;
        SET @PFX_ck_expected_definition           = NULL;
        SET @PFX_ck_protected_literal             = NULL;

        SET @PFX_ck_expected_working_definition   = NULL;
        SET @PFX_ck_expected_signature            = NULL;

        SET @PFX_ck_actual_name                   = NULL;
        SET @PFX_ck_actual_definition             = NULL;
        SET @PFX_ck_actual_working_definition     = NULL;
        SET @PFX_ck_actual_signature              = NULL;
        SET @PFX_ck_actual_is_disabled            = NULL;
        SET @PFX_ck_actual_is_not_trusted         = NULL;

        SET @PFX_ck_equivalent_name               = NULL;
        SET @PFX_ck_equivalent_definition         = NULL;
        SET @PFX_ck_equivalent_is_disabled        = NULL;
        SET @PFX_ck_equivalent_is_not_trusted     = NULL;

        SET @PFX_ck_parent_object                 = NULL;
        SET @PFX_ck_qualified_name                = NULL;
        SET @PFX_ck_sql                           = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @PFX_ck_expected_name =
                PFX_ck_name,

            @PFX_ck_column_name =
                PFX_column_name,

            @PFX_ck_expected_definition =
                PFX_expected_definition,

            @PFX_ck_protected_literal =
                PFX_protected_literal

        FROM @PFX_expected_checks
        WHERE PFX_ck_id = @PFX_ck_current_id;


        /*----------------------------------------------------------------------
            BUILD EXPECTED CANONICAL SIGNATURE
        ----------------------------------------------------------------------*/

        SET @PFX_ck_expected_working_definition =
            @PFX_ck_expected_definition;


        /*
            Protect case-sensitive literals before normalizing SQL syntax.
        */

        IF @PFX_ck_protected_literal IS NOT NULL
        BEGIN
            SET @PFX_ck_expected_working_definition =
                REPLACE
                (
                    @PFX_ck_expected_working_definition,
                    @PFX_ck_protected_literal,
                    N'__ATLAS_PROTECTED_LITERAL__'
                );
        END;


        /*
            Remove identifier brackets only from the managed column.

            Do not remove square brackets globally because expressions such
            as [^A-Z] use them as meaningful LIKE pattern syntax.
        */

        SET @PFX_ck_expected_working_definition =
            REPLACE
            (
                @PFX_ck_expected_working_definition,
                N'[' + @PFX_ck_column_name + N']',
                @PFX_ck_column_name
            );


        /*
            Normalize non-semantic SQL formatting differences.
        */

        SET @PFX_ck_expected_signature =
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
                                        @PFX_ck_expected_working_definition,
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
            @PFX_ck_actual_name =
                cc.name,

            @PFX_ck_actual_definition =
                cc.definition,

            @PFX_ck_actual_is_disabled =
                cc.is_disabled,

            @PFX_ck_actual_is_not_trusted =
                cc.is_not_trusted

        FROM sys.check_constraints AS cc
        WHERE cc.parent_object_id =
                OBJECT_ID(N'metadata.TablePrefix')
          AND cc.name =
                @PFX_ck_expected_name;


        /*======================================================================
            EXPECTED CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @PFX_ck_actual_name IS NOT NULL
        BEGIN

            /*------------------------------------------------------------------
                BUILD ACTUAL CANONICAL SIGNATURE
            ------------------------------------------------------------------*/

            SET @PFX_ck_actual_working_definition =
                @PFX_ck_actual_definition;


            IF @PFX_ck_protected_literal IS NOT NULL
            BEGIN
                SET @PFX_ck_actual_working_definition =
                    REPLACE
                    (
                        @PFX_ck_actual_working_definition,
                        @PFX_ck_protected_literal,
                        N'__ATLAS_PROTECTED_LITERAL__'
                    );
            END;


            SET @PFX_ck_actual_working_definition =
                REPLACE
                (
                    @PFX_ck_actual_working_definition,
                    N'[' + @PFX_ck_column_name + N']',
                    @PFX_ck_column_name
                );


            SET @PFX_ck_actual_signature =
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
                                            @PFX_ck_actual_working_definition,
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

            IF @PFX_ck_actual_signature COLLATE Latin1_General_100_BIN2
                    =
               @PFX_ck_expected_signature COLLATE Latin1_General_100_BIN2

               AND @PFX_ck_actual_is_disabled = 0
               AND @PFX_ck_actual_is_not_trusted = 0
            BEGIN
                PRINT N'        [•] Check constraint validated      : '
                    + @PFX_ck_expected_name;

                PRINT N'            Column                          : '
                    + @PFX_ck_column_name;

                PRINT N'            Definition                      : '
                    + @PFX_ck_expected_definition;
            END

            ELSE
            BEGIN

                /*--------------------------------------------------------------
                    EXPECTED NAME EXISTS BUT DEFINITION OR STATE DIFFERS
                --------------------------------------------------------------*/

                PRINT N'        [!] Check constraint mismatch       : '
                    + @PFX_ck_expected_name;

                PRINT N'            Expected Name                   : '
                    + @PFX_ck_expected_name;

                PRINT N'            Actual Name                     : '
                    + COALESCE
                      (
                          @PFX_ck_actual_name,
                          N'<NULL>'
                      );

                PRINT N'            Expected Definition             : '
                    + @PFX_ck_expected_definition;

                PRINT N'            Actual Definition               : '
                    + COALESCE
                      (
                          @PFX_ck_actual_definition,
                          N'<NULL>'
                      );

                PRINT N'            Expected Disabled               : 0';

                PRINT N'            Actual Disabled                 : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @PFX_ck_actual_is_disabled
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Expected Not Trusted            : 0';

                PRINT N'            Actual Not Trusted              : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @PFX_ck_actual_is_not_trusted
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

                @PFX_ck_equivalent_name =
                    cc.name,

                @PFX_ck_equivalent_definition =
                    cc.definition,

                @PFX_ck_equivalent_is_disabled =
                    cc.is_disabled,

                @PFX_ck_equivalent_is_not_trusted =
                    cc.is_not_trusted

            FROM sys.check_constraints AS cc

            CROSS APPLY
            (
                SELECT
                    CASE
                        WHEN @PFX_ck_protected_literal IS NOT NULL
                        THEN
                            REPLACE
                            (
                                cc.definition,
                                @PFX_ck_protected_literal,
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
                        N'[' + @PFX_ck_column_name + N']',
                        @PFX_ck_column_name
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
                    OBJECT_ID(N'metadata.TablePrefix')

              AND cc.name <>
                    @PFX_ck_expected_name

              AND ds.definition_signature COLLATE Latin1_General_100_BIN2
                    =
                  @PFX_ck_expected_signature COLLATE Latin1_General_100_BIN2

            ORDER BY
                cc.name;


            /*------------------------------------------------------------------
                EQUIVALENT CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @PFX_ck_equivalent_name IS NOT NULL
            BEGIN
                PRINT N'        [!] Check constraint naming mismatch: '
                    + @PFX_ck_column_name;

                PRINT N'            Expected Name                   : '
                    + @PFX_ck_expected_name;

                PRINT N'            Actual Name                     : '
                    + @PFX_ck_equivalent_name;

                PRINT N'            Expected Definition             : '
                    + @PFX_ck_expected_definition;

                PRINT N'            Actual Definition               : '
                    + COALESCE
                      (
                          @PFX_ck_equivalent_definition,
                          N'<NULL>'
                      );

                PRINT N'            Expected Disabled               : 0';

                PRINT N'            Actual Disabled                 : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @PFX_ck_equivalent_is_disabled
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Expected Not Trusted            : 0';

                PRINT N'            Actual Not Trusted              : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @PFX_ck_equivalent_is_not_trusted
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

                SET @PFX_ck_qualified_name =
                    N'metadata.'
                    + @PFX_ck_expected_name;


                IF OBJECT_ID
                   (
                       @PFX_ck_qualified_name,
                       N'C'
                   ) IS NOT NULL
                BEGIN
                    SELECT
                        @PFX_ck_parent_object =
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
                            @PFX_ck_qualified_name,
                            N'C'
                        );


                    PRINT N'        [!] Check constraint name conflict : '
                        + @PFX_ck_expected_name;

                    PRINT N'            Expected Table                  : metadata.TablePrefix';

                    PRINT N'            Expected Column                 : '
                        + @PFX_ck_column_name;

                    PRINT N'            Existing Parent                 : '
                        + COALESCE
                          (
                              @PFX_ck_parent_object,
                              N'<UNKNOWN>'
                          );

                    PRINT N'            Constraint was not created. Manual review is required.';


                    ;THROW 50003,
                        N'Check constraint name conflict prevents safe deployment.',
                        1;
                END;


                /*--------------------------------------------------------------
                    CREATE EXPECTED CONSTRAINT
                --------------------------------------------------------------*/

                SET @PFX_ck_sql =
                    N'ALTER TABLE metadata.TablePrefix
                        WITH CHECK
                        ADD CONSTRAINT '
                    + QUOTENAME(@PFX_ck_expected_name)
                    + N'
                        CHECK
                        (
                            '
                    + @PFX_ck_expected_definition
                    + N'
                        );

                      ALTER TABLE metadata.TablePrefix
                        CHECK CONSTRAINT '
                    + QUOTENAME(@PFX_ck_expected_name)
                    + N';';


                EXEC sys.sp_executesql
                    @PFX_ck_sql;


                PRINT N'        [+] Check constraint added          : '
                    + @PFX_ck_expected_name;

                PRINT N'            Column                          : '
                    + @PFX_ck_column_name;

                PRINT N'            Definition                      : '
                    + @PFX_ck_expected_definition;
            END;
        END;


        SET @PFX_ck_current_id =
            @PFX_ck_current_id + 1;

    END;


    PRINT N'';