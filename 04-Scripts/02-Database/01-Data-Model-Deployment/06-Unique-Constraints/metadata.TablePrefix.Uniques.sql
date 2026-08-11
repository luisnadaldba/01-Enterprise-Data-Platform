    PRINT N'    metadata.TablePrefix';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        EXPECTED UNIQUE CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @PFX_expected_uniques TABLE
    (
        PFX_uq_id               tinyint IDENTITY(1,1) NOT NULL,
        PFX_uq_name             sysname               NOT NULL,
        PFX_expected_columns    nvarchar(4000)         NOT NULL,
        PFX_create_columns      nvarchar(4000)         NOT NULL
    );


    /*--------------------------------------------------------------------------
        UQ_PFX_prefix

        Rule:
            A table prefix must be globally unique within AtlasCommerce.
    --------------------------------------------------------------------------*/

    INSERT INTO @PFX_expected_uniques
    (
        PFX_uq_name,
        PFX_expected_columns,
        PFX_create_columns
    )
    VALUES
    (
        N'UQ_PFX_prefix',
        N'PFX_prefix',
        N'[PFX_prefix]'
    );


    /*--------------------------------------------------------------------------
        UQ_PFX_table

        Rule:
            A canonical table identified by schema + table name may have only
            one prefix registration.

        The same table name may exist in different schemas, but the same
        schema.TableName combination must not be registered more than once.
    --------------------------------------------------------------------------*/

    INSERT INTO @PFX_expected_uniques
    (
        PFX_uq_name,
        PFX_expected_columns,
        PFX_create_columns
    )
    VALUES
    (
        N'UQ_PFX_table',
        N'PFX_schema_name|PFX_table_name',
        N'[PFX_schema_name], [PFX_table_name]'
    );


    /*==========================================================================
        UNIQUE CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @PFX_uq_current_id                  tinyint;
    DECLARE @PFX_uq_max_id                      tinyint;

    DECLARE @PFX_uq_expected_name               sysname;
    DECLARE @PFX_uq_expected_columns            nvarchar(4000);
    DECLARE @PFX_uq_create_columns              nvarchar(4000);

    DECLARE @PFX_uq_actual_name                 sysname;
    DECLARE @PFX_uq_actual_columns              nvarchar(4000);
    DECLARE @PFX_uq_actual_index_name           sysname;
    DECLARE @PFX_uq_actual_is_disabled          bit;

    DECLARE @PFX_uq_equivalent_name             sysname;
    DECLARE @PFX_uq_equivalent_columns          nvarchar(4000);
    DECLARE @PFX_uq_equivalent_index_name       sysname;
    DECLARE @PFX_uq_equivalent_is_disabled      bit;

    DECLARE @PFX_uq_unique_index_name           sysname;
    DECLARE @PFX_uq_unique_index_columns        nvarchar(4000);
    DECLARE @PFX_uq_unique_index_is_disabled    bit;

    DECLARE @PFX_uq_parent_object               nvarchar(517);
    DECLARE @PFX_uq_qualified_name              nvarchar(517);

    DECLARE @PFX_uq_sql                         nvarchar(max);


    SELECT
        @PFX_uq_current_id = MIN(PFX_uq_id),
        @PFX_uq_max_id     = MAX(PFX_uq_id)
    FROM @PFX_expected_uniques;


    WHILE @PFX_uq_current_id <= @PFX_uq_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT UNIQUE CONSTRAINT STATE
        ----------------------------------------------------------------------*/

        SET @PFX_uq_expected_name              = NULL;
        SET @PFX_uq_expected_columns           = NULL;
        SET @PFX_uq_create_columns             = NULL;

        SET @PFX_uq_actual_name                = NULL;
        SET @PFX_uq_actual_columns             = NULL;
        SET @PFX_uq_actual_index_name          = NULL;
        SET @PFX_uq_actual_is_disabled         = NULL;

        SET @PFX_uq_equivalent_name            = NULL;
        SET @PFX_uq_equivalent_columns         = NULL;
        SET @PFX_uq_equivalent_index_name      = NULL;
        SET @PFX_uq_equivalent_is_disabled     = NULL;

        SET @PFX_uq_unique_index_name          = NULL;
        SET @PFX_uq_unique_index_columns       = NULL;
        SET @PFX_uq_unique_index_is_disabled   = NULL;

        SET @PFX_uq_parent_object              = NULL;
        SET @PFX_uq_qualified_name             = NULL;

        SET @PFX_uq_sql                        = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @PFX_uq_expected_name =
                PFX_uq_name,

            @PFX_uq_expected_columns =
                PFX_expected_columns,

            @PFX_uq_create_columns =
                PFX_create_columns

        FROM @PFX_expected_uniques
        WHERE PFX_uq_id = @PFX_uq_current_id;


        /*----------------------------------------------------------------------
            LOOK FOR EXPECTED UNIQUE CONSTRAINT NAME
        ----------------------------------------------------------------------*/

        SELECT
            @PFX_uq_actual_name =
                kc.name,

            @PFX_uq_actual_index_name =
                i.name,

            @PFX_uq_actual_is_disabled =
                i.is_disabled,

            @PFX_uq_actual_columns =
            (
                SELECT
                    STRING_AGG
                    (
                        CONVERT(nvarchar(max), c.name),
                        N'|'
                    )
                    WITHIN GROUP
                    (
                        ORDER BY ic.key_ordinal
                    )

                FROM sys.index_columns AS ic
                INNER JOIN sys.columns AS c
                    ON  c.object_id = ic.object_id
                    AND c.column_id = ic.column_id

                WHERE ic.object_id = kc.parent_object_id
                  AND ic.index_id = kc.unique_index_id
                  AND ic.key_ordinal > 0
            )

        FROM sys.key_constraints AS kc
        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'metadata.TablePrefix')

          AND kc.type = N'UQ'

          AND kc.name =
                @PFX_uq_expected_name;


        /*======================================================================
            EXPECTED UNIQUE CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @PFX_uq_actual_name IS NOT NULL
        BEGIN

            IF @PFX_uq_actual_columns COLLATE Latin1_General_100_BIN2
                    =
               @PFX_uq_expected_columns COLLATE Latin1_General_100_BIN2

               AND @PFX_uq_actual_is_disabled = 0
            BEGIN
                PRINT N'        [•] Unique constraint validated     : '
                    + @PFX_uq_expected_name;

                PRINT N'            Columns                         : '
                    + REPLACE
                      (
                          @PFX_uq_expected_columns,
                          N'|',
                          N', '
                      );
            END

            ELSE
            BEGIN

                /*--------------------------------------------------------------
                    EXPECTED NAME EXISTS BUT DEFINITION OR STATE DIFFERS
                --------------------------------------------------------------*/

                PRINT N'        [!] Unique constraint mismatch      : '
                    + @PFX_uq_expected_name;

                PRINT N'            Expected Name                   : '
                    + @PFX_uq_expected_name;

                PRINT N'            Actual Name                     : '
                    + COALESCE
                      (
                          @PFX_uq_actual_name,
                          N'<NULL>'
                      );

                PRINT N'            Expected Columns                : '
                    + REPLACE
                      (
                          @PFX_uq_expected_columns,
                          N'|',
                          N', '
                      );

                PRINT N'            Actual Columns                  : '
                    + COALESCE
                      (
                          REPLACE
                          (
                              @PFX_uq_actual_columns,
                              N'|',
                              N', '
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Expected Disabled               : 0';

                PRINT N'            Actual Disabled                 : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @PFX_uq_actual_is_disabled
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Existing constraint was preserved for review.';
            END;
        END

        /*======================================================================
            EXPECTED UNIQUE CONSTRAINT NAME DOES NOT EXIST
        ======================================================================*/

        ELSE
        BEGIN

            /*------------------------------------------------------------------
                SEARCH FOR FUNCTIONALLY EQUIVALENT UQ WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            SELECT TOP (1)

                @PFX_uq_equivalent_name =
                    uq.UQ_name,

                @PFX_uq_equivalent_columns =
                    uq.UQ_columns,

                @PFX_uq_equivalent_index_name =
                    uq.UQ_index_name,

                @PFX_uq_equivalent_is_disabled =
                    uq.UQ_is_disabled

            FROM
            (
                SELECT
                    kc.name AS UQ_name,

                    i.name AS UQ_index_name,

                    i.is_disabled AS UQ_is_disabled,

                    (
                        SELECT
                            STRING_AGG
                            (
                                CONVERT(nvarchar(max), c.name),
                                N'|'
                            )
                            WITHIN GROUP
                            (
                                ORDER BY ic.key_ordinal
                            )

                        FROM sys.index_columns AS ic
                        INNER JOIN sys.columns AS c
                            ON  c.object_id = ic.object_id
                            AND c.column_id = ic.column_id

                        WHERE ic.object_id =
                                kc.parent_object_id

                          AND ic.index_id =
                                kc.unique_index_id

                          AND ic.key_ordinal > 0
                    ) AS UQ_columns

                FROM sys.key_constraints AS kc
                INNER JOIN sys.indexes AS i
                    ON  i.object_id = kc.parent_object_id
                    AND i.index_id = kc.unique_index_id

                WHERE kc.parent_object_id =
                        OBJECT_ID(N'metadata.TablePrefix')

                  AND kc.type = N'UQ'

                  AND kc.name <>
                        @PFX_uq_expected_name

            ) AS uq

            WHERE uq.UQ_columns COLLATE Latin1_General_100_BIN2
                    =
                  @PFX_uq_expected_columns COLLATE Latin1_General_100_BIN2

            ORDER BY
                uq.UQ_name;


            /*------------------------------------------------------------------
                EQUIVALENT UNIQUE CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @PFX_uq_equivalent_name IS NOT NULL
            BEGIN
                PRINT N'        [!] Unique constraint naming mismatch';

                PRINT N'            Expected Name                   : '
                    + @PFX_uq_expected_name;

                PRINT N'            Actual Name                     : '
                    + @PFX_uq_equivalent_name;

                PRINT N'            Expected Columns                : '
                    + REPLACE
                      (
                          @PFX_uq_expected_columns,
                          N'|',
                          N', '
                      );

                PRINT N'            Actual Columns                  : '
                    + REPLACE
                      (
                          @PFX_uq_equivalent_columns,
                          N'|',
                          N', '
                      );

                PRINT N'            Expected Disabled               : 0';

                PRINT N'            Actual Disabled                 : '
                    + COALESCE
                      (
                          CONVERT
                          (
                              nvarchar(1),
                              @PFX_uq_equivalent_is_disabled
                          ),
                          N'<NULL>'
                      );

                PRINT N'            Existing constraint was preserved for review.';
            END

            ELSE
            BEGIN

                /*--------------------------------------------------------------
                    SEARCH FOR EQUIVALENT UNIQUE INDEX WITHOUT UQ
                --------------------------------------------------------------*/

                SELECT TOP (1)

                    @PFX_uq_unique_index_name =
                        idx.IndexName,

                    @PFX_uq_unique_index_columns =
                        idx.IndexColumns,

                    @PFX_uq_unique_index_is_disabled =
                        idx.IsDisabled

                FROM
                (
                    SELECT
                        i.name AS IndexName,

                        i.is_disabled AS IsDisabled,

                        (
                            SELECT
                                STRING_AGG
                                (
                                    CONVERT(nvarchar(max), c.name),
                                    N'|'
                                )
                                WITHIN GROUP
                                (
                                    ORDER BY ic.key_ordinal
                                )

                            FROM sys.index_columns AS ic
                            INNER JOIN sys.columns AS c
                                ON  c.object_id = ic.object_id
                                AND c.column_id = ic.column_id

                            WHERE ic.object_id = i.object_id
                              AND ic.index_id = i.index_id
                              AND ic.key_ordinal > 0

                        ) AS IndexColumns

                    FROM sys.indexes AS i

                    WHERE i.object_id =
                            OBJECT_ID(N'metadata.TablePrefix')

                      AND i.is_unique = 1

                      AND i.is_unique_constraint = 0

                      AND i.is_primary_key = 0

                      AND i.is_hypothetical = 0

                ) AS idx

                WHERE idx.IndexColumns COLLATE Latin1_General_100_BIN2
                        =
                      @PFX_uq_expected_columns COLLATE Latin1_General_100_BIN2

                ORDER BY
                    idx.IndexName;


                /*--------------------------------------------------------------
                    UNIQUE INDEX EXISTS BUT REQUIRED UQ DOES NOT
                --------------------------------------------------------------*/

                IF @PFX_uq_unique_index_name IS NOT NULL
                BEGIN
                    PRINT N'        [!] Unique constraint type mismatch  : '
                        + @PFX_uq_expected_name;

                    PRINT N'            Expected Object Type            : UNIQUE CONSTRAINT';

                    PRINT N'            Actual Object Type              : UNIQUE INDEX';

                    PRINT N'            Actual Index                    : '
                        + @PFX_uq_unique_index_name;

                    PRINT N'            Expected Columns                : '
                        + REPLACE
                          (
                              @PFX_uq_expected_columns,
                              N'|',
                              N', '
                          );

                    PRINT N'            Actual Columns                  : '
                        + REPLACE
                          (
                              @PFX_uq_unique_index_columns,
                              N'|',
                              N', '
                          );

                    PRINT N'            Existing unique index was preserved for review.';

                    PRINT N'            Unique constraint was not created to avoid duplicate structures.';
                END

                ELSE
                BEGIN

                    /*----------------------------------------------------------
                        VALIDATE THAT EXPECTED NAME IS NOT USED ELSEWHERE
                    ----------------------------------------------------------*/

                    SET @PFX_uq_qualified_name =
                        N'metadata.'
                        + @PFX_uq_expected_name;


                    IF OBJECT_ID
                       (
                           @PFX_uq_qualified_name,
                           N'UQ'
                       ) IS NOT NULL
                    BEGIN
                        SELECT
                            @PFX_uq_parent_object =
                                QUOTENAME
                                (
                                    OBJECT_SCHEMA_NAME
                                    (
                                        kc.parent_object_id
                                    )
                                )
                                + N'.'
                                + QUOTENAME
                                  (
                                      OBJECT_NAME
                                      (
                                          kc.parent_object_id
                                      )
                                  )

                        FROM sys.key_constraints AS kc

                        WHERE kc.object_id =
                            OBJECT_ID
                            (
                                @PFX_uq_qualified_name,
                                N'UQ'
                            );


                        PRINT N'        [!] Unique constraint name conflict : '
                            + @PFX_uq_expected_name;

                        PRINT N'            Expected Table                  : metadata.TablePrefix';

                        PRINT N'            Existing Parent                 : '
                            + COALESCE
                              (
                                  @PFX_uq_parent_object,
                                  N'<UNKNOWN>'
                              );

                        PRINT N'            Constraint was not created. Manual review is required.';


                        ;THROW 50004,
                            N'Unique constraint name conflict prevents safe deployment.',
                            1;
                    END;


                    /*----------------------------------------------------------
                        CREATE EXPECTED UNIQUE CONSTRAINT
                    ----------------------------------------------------------*/

                    SET @PFX_uq_sql =
                        N'ALTER TABLE metadata.TablePrefix
                            ADD CONSTRAINT '
                        + QUOTENAME(@PFX_uq_expected_name)
                        + N'
                            UNIQUE
                            (
                                '
                        + @PFX_uq_create_columns
                        + N'
                            );';


                    EXEC sys.sp_executesql
                        @PFX_uq_sql;


                    PRINT N'        [+] Unique constraint added         : '
                        + @PFX_uq_expected_name;

                    PRINT N'            Columns                         : '
                        + REPLACE
                          (
                              @PFX_uq_expected_columns,
                              N'|',
                              N', '
                          );
                END;
            END;
        END;


        SET @PFX_uq_current_id =
            @PFX_uq_current_id + 1;

    END;


    PRINT N'';