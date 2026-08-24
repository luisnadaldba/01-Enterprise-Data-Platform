    PRINT N'';
    PRINT N'    ● sales.Transaction';
    PRINT N'';


    /*==========================================================================
        EXPECTED CHECK CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @TRN_expected_checks TABLE
    (
        TRN_ck_id                   tinyint IDENTITY(1,1) NOT NULL,
        TRN_ck_name                 sysname               NOT NULL,
        TRN_column_label            nvarchar(20)           NOT NULL,
        TRN_column_names            nvarchar(4000)         NOT NULL,
        TRN_expected_definition     nvarchar(4000)         NOT NULL
    );


    /*--------------------------------------------------------------------------
        CK_TRN_gross_amount

        Rule:
            Gross transaction amount cannot be negative.
    --------------------------------------------------------------------------*/

    INSERT INTO @TRN_expected_checks
    (
        TRN_ck_name,
        TRN_column_label,
        TRN_column_names,
        TRN_expected_definition
    )
    VALUES
    (
        N'CK_TRN_gross_amount',
        N'Column',
        N'TRN_gross_amount',
        N'TRN_gross_amount >= 0.00'
    );


    /*--------------------------------------------------------------------------
        CK_TRN_discount_amount

        Rule:
            Transaction-level discount cannot be negative.
    --------------------------------------------------------------------------*/

    INSERT INTO @TRN_expected_checks
    (
        TRN_ck_name,
        TRN_column_label,
        TRN_column_names,
        TRN_expected_definition
    )
    VALUES
    (
        N'CK_TRN_discount_amount',
        N'Column',
        N'TRN_discount_amount',
        N'TRN_discount_amount >= 0.00'
    );


    /*--------------------------------------------------------------------------
        CK_TRN_discount_not_greater_than_gross_amount

        Rule:
            Transaction-level discount cannot exceed the gross transaction
            amount.
    --------------------------------------------------------------------------*/

    INSERT INTO @TRN_expected_checks
    (
        TRN_ck_name,
        TRN_column_label,
        TRN_column_names,
        TRN_expected_definition
    )
    VALUES
    (
        N'CK_TRN_discount_not_greater_than_gross_amount',
        N'Columns',
        N'TRN_discount_amount, TRN_gross_amount',
        N'TRN_discount_amount <= TRN_gross_amount'
    );


    /*==========================================================================
        CHECK CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @TRN_ck_current_id                     tinyint;
    DECLARE @TRN_ck_max_id                         tinyint;

    DECLARE @TRN_ck_expected_name                  sysname;
    DECLARE @TRN_ck_column_label                   nvarchar(20);
    DECLARE @TRN_ck_column_names                   nvarchar(4000);
    DECLARE @TRN_ck_expected_definition            nvarchar(4000);

    DECLARE @TRN_ck_expected_working_definition    nvarchar(4000);
    DECLARE @TRN_ck_expected_signature             nvarchar(4000);

    DECLARE @TRN_ck_actual_name                    sysname;
    DECLARE @TRN_ck_actual_definition              nvarchar(4000);
    DECLARE @TRN_ck_actual_working_definition      nvarchar(4000);
    DECLARE @TRN_ck_actual_signature               nvarchar(4000);
    DECLARE @TRN_ck_actual_is_disabled             bit;
    DECLARE @TRN_ck_actual_is_not_trusted          bit;

    DECLARE @TRN_ck_equivalent_name                sysname;
    DECLARE @TRN_ck_equivalent_definition          nvarchar(4000);
    DECLARE @TRN_ck_equivalent_is_disabled         bit;
    DECLARE @TRN_ck_equivalent_is_not_trusted      bit;

    DECLARE @TRN_ck_parent_object                  nvarchar(517);
    DECLARE @TRN_ck_qualified_name                 nvarchar(517);

    DECLARE @TRN_ck_sql                            nvarchar(max);


    SELECT
        @TRN_ck_current_id = MIN(TRN_ck_id),
        @TRN_ck_max_id     = MAX(TRN_ck_id)
    FROM @TRN_expected_checks;


    WHILE @TRN_ck_current_id <= @TRN_ck_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT CHECK STATE
        ----------------------------------------------------------------------*/

        SET @TRN_ck_expected_name                 = NULL;
        SET @TRN_ck_column_label                  = NULL;
        SET @TRN_ck_column_names                  = NULL;
        SET @TRN_ck_expected_definition           = NULL;

        SET @TRN_ck_expected_working_definition   = NULL;
        SET @TRN_ck_expected_signature            = NULL;

        SET @TRN_ck_actual_name                   = NULL;
        SET @TRN_ck_actual_definition             = NULL;
        SET @TRN_ck_actual_working_definition     = NULL;
        SET @TRN_ck_actual_signature              = NULL;
        SET @TRN_ck_actual_is_disabled            = NULL;
        SET @TRN_ck_actual_is_not_trusted         = NULL;

        SET @TRN_ck_equivalent_name               = NULL;
        SET @TRN_ck_equivalent_definition         = NULL;
        SET @TRN_ck_equivalent_is_disabled        = NULL;
        SET @TRN_ck_equivalent_is_not_trusted     = NULL;

        SET @TRN_ck_parent_object                 = NULL;
        SET @TRN_ck_qualified_name                = NULL;
        SET @TRN_ck_sql                           = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @TRN_ck_expected_name =
                TRN_ck_name,

            @TRN_ck_column_label =
                TRN_column_label,

            @TRN_ck_column_names =
                TRN_column_names,

            @TRN_ck_expected_definition =
                TRN_expected_definition

        FROM @TRN_expected_checks
        WHERE TRN_ck_id = @TRN_ck_current_id;


        /*----------------------------------------------------------------------
            BUILD EXPECTED CANONICAL SIGNATURE
        ----------------------------------------------------------------------*/

        SET @TRN_ck_expected_working_definition =
            @TRN_ck_expected_definition;


        /*
            Remove identifier brackets from the managed Transaction columns.

            These expressions contain no literals in which square brackets
            carry semantic meaning.
        */

        SET @TRN_ck_expected_working_definition =
            REPLACE
            (
                @TRN_ck_expected_working_definition,
                N'[TRN_gross_amount]',
                N'TRN_gross_amount'
            );

        SET @TRN_ck_expected_working_definition =
            REPLACE
            (
                @TRN_ck_expected_working_definition,
                N'[TRN_discount_amount]',
                N'TRN_discount_amount'
            );


        /*
            Normalize non-semantic SQL formatting differences.
        */

        SET @TRN_ck_expected_signature =
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
                                        @TRN_ck_expected_working_definition,
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
            @TRN_ck_actual_name =
                cc.name,

            @TRN_ck_actual_definition =
                cc.definition,

            @TRN_ck_actual_is_disabled =
                cc.is_disabled,

            @TRN_ck_actual_is_not_trusted =
                cc.is_not_trusted

        FROM sys.check_constraints AS cc
        WHERE cc.parent_object_id =
                OBJECT_ID(N'sales.[Transaction]')
          AND cc.name =
                @TRN_ck_expected_name;


        /*======================================================================
            EXPECTED CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @TRN_ck_actual_name IS NOT NULL
        BEGIN

            /*------------------------------------------------------------------
                BUILD ACTUAL CANONICAL SIGNATURE
            ------------------------------------------------------------------*/

            SET @TRN_ck_actual_working_definition =
                @TRN_ck_actual_definition;


            SET @TRN_ck_actual_working_definition =
                REPLACE
                (
                    @TRN_ck_actual_working_definition,
                    N'[TRN_gross_amount]',
                    N'TRN_gross_amount'
                );

            SET @TRN_ck_actual_working_definition =
                REPLACE
                (
                    @TRN_ck_actual_working_definition,
                    N'[TRN_discount_amount]',
                    N'TRN_discount_amount'
                );


            SET @TRN_ck_actual_signature =
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
                                            @TRN_ck_actual_working_definition,
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

            IF @TRN_ck_actual_signature COLLATE Latin1_General_100_BIN2
                    =
               @TRN_ck_expected_signature COLLATE Latin1_General_100_BIN2

               AND @TRN_ck_actual_is_disabled = 0
               AND @TRN_ck_actual_is_not_trusted = 0
            BEGIN

                PRINT N'        [•] Check constraint validated     : '
                    + @TRN_ck_expected_name;

                PRINT N'            '
                    + @TRN_ck_column_label
                    + REPLICATE
                      (
                          N' ',
                          31 - LEN(@TRN_ck_column_label)
                      )
                    + N': '
                    + @TRN_ck_column_names;

                PRINT N'            Definition                     : CHECK ('
                    + @TRN_ck_expected_definition
                    + N')';

            END

            ELSE
            BEGIN

                /*--------------------------------------------------------------
                    EXPECTED NAME EXISTS BUT DEFINITION OR STATE DIFFERS
                --------------------------------------------------------------*/

                PRINT N'        [!] Check constraint mismatch      : '
                    + @TRN_ck_expected_name;

                PRINT N'            Expected Name                  : '
                    + @TRN_ck_expected_name;

                PRINT N'            Actual Name                    : '
                    + COALESCE
                      (
                          @TRN_ck_actual_name,
                          N'<NULL>'
                      );

                PRINT N'            Expected Definition            : CHECK ('
                    + @TRN_ck_expected_definition
                    + N')';

                PRINT N'            Actual Definition              : '
                    + COALESCE
                      (
                          @TRN_ck_actual_definition,
                          N'<NULL>'
                      );

                PRINT N'            Expected Disabled              : 0';

                PRINT N'            Actual Disabled                : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @TRN_ck_actual_is_disabled
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
                              @TRN_ck_actual_is_not_trusted
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

                @TRN_ck_equivalent_name =
                    cc.name,

                @TRN_ck_equivalent_definition =
                    cc.definition,

                @TRN_ck_equivalent_is_disabled =
                    cc.is_disabled,

                @TRN_ck_equivalent_is_not_trusted =
                    cc.is_not_trusted

            FROM sys.check_constraints AS cc

            CROSS APPLY
            (
                SELECT
                    REPLACE
                    (
                        REPLACE
                        (
                            cc.definition,
                            N'[TRN_gross_amount]',
                            N'TRN_gross_amount'
                        ),
                        N'[TRN_discount_amount]',
                        N'TRN_discount_amount'
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
                    OBJECT_ID(N'sales.[Transaction]')

              AND cc.name <>
                    @TRN_ck_expected_name

              AND ds.definition_signature COLLATE Latin1_General_100_BIN2
                    =
                  @TRN_ck_expected_signature COLLATE Latin1_General_100_BIN2

            ORDER BY
                cc.name;


            /*------------------------------------------------------------------
                EQUIVALENT CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @TRN_ck_equivalent_name IS NOT NULL
            BEGIN

                PRINT N'        [!] Check constraint naming mismatch: '
                    + @TRN_ck_column_names;

                PRINT N'            Expected Name                  : '
                    + @TRN_ck_expected_name;

                PRINT N'            Actual Name                    : '
                    + @TRN_ck_equivalent_name;

                PRINT N'            Expected Definition            : CHECK ('
                    + @TRN_ck_expected_definition
                    + N')';

                PRINT N'            Actual Definition              : '
                    + COALESCE
                      (
                          @TRN_ck_equivalent_definition,
                          N'<NULL>'
                      );

                PRINT N'            Expected Disabled              : 0';

                PRINT N'            Actual Disabled                : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @TRN_ck_equivalent_is_disabled
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
                              @TRN_ck_equivalent_is_not_trusted
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

                SET @TRN_ck_qualified_name =
                    N'sales.'
                    + @TRN_ck_expected_name;


                IF OBJECT_ID
                   (
                       @TRN_ck_qualified_name,
                       N'C'
                   ) IS NOT NULL
                BEGIN

                    SELECT
                        @TRN_ck_parent_object =
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
                            @TRN_ck_qualified_name,
                            N'C'
                        );


                    PRINT N'        [!] Check constraint name conflict : '
                        + @TRN_ck_expected_name;

                    PRINT N'            Expected Table                : sales.Transaction';

                    PRINT N'            Expected '
                        + @TRN_ck_column_label
                        + REPLICATE
                          (
                              N' ',
                              20 - LEN(@TRN_ck_column_label)
                          )
                        + N': '
                        + @TRN_ck_column_names;

                    PRINT N'            Existing Parent               : '
                        + COALESCE
                          (
                              @TRN_ck_parent_object,
                              N'<UNKNOWN>'
                          );

                    PRINT N'            Constraint was not created. Manual review is required.';


                    ;THROW 50052,
                        N'Check constraint name conflict prevents safe deployment.',
                        1;

                END;


                /*--------------------------------------------------------------
                    CREATE EXPECTED CONSTRAINT
                --------------------------------------------------------------*/

                SET @TRN_ck_sql =
                    N'ALTER TABLE sales.[Transaction]
                        WITH CHECK
                        ADD CONSTRAINT '
                    + QUOTENAME(@TRN_ck_expected_name)
                    + N'
                        CHECK
                        (
                            '
                    + @TRN_ck_expected_definition
                    + N'
                        );

                      ALTER TABLE sales.[Transaction]
                        CHECK CONSTRAINT '
                    + QUOTENAME(@TRN_ck_expected_name)
                    + N';';


                EXEC sys.sp_executesql
                    @TRN_ck_sql;


                PRINT N'        [+] Check constraint added         : '
                    + @TRN_ck_expected_name;

                PRINT N'            '
                    + @TRN_ck_column_label
                    + REPLICATE
                      (
                          N' ',
                          31 - LEN(@TRN_ck_column_label)
                      )
                    + N': '
                    + @TRN_ck_column_names;

                PRINT N'            Definition                     : CHECK ('
                    + @TRN_ck_expected_definition
                    + N')';

            END;

        END;


        SET @TRN_ck_current_id =
            @TRN_ck_current_id + 1;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';