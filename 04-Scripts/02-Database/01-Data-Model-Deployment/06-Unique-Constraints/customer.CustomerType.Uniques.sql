    PRINT N'';
    PRINT N'    ● customer.CustomerType';
    PRINT N'';


    /*==========================================================================
        EXPECTED UNIQUE CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @CSTCT_UQ_expected_uniques TABLE
    (
        CSTCT_uq_id               tinyint IDENTITY(1,1) NOT NULL,
        CSTCT_uq_name             sysname               NOT NULL,
        CSTCT_expected_columns    nvarchar(4000)         NOT NULL,
        CSTCT_create_columns      nvarchar(4000)         NOT NULL
    );


    /*--------------------------------------------------------------------------
        UQ_CSTCT_code

        Rule:
            Each customer type must have a unique technical code.

            The code provides a stable identifier independently from the
            descriptive customer type name.
    --------------------------------------------------------------------------*/

    INSERT INTO @CSTCT_UQ_expected_uniques
    (
        CSTCT_uq_name,
        CSTCT_expected_columns,
        CSTCT_create_columns
    )
    VALUES
    (
        N'UQ_CSTCT_code',
        N'CSTCT_code',
        N'[CSTCT_code]'
    );


    /*==========================================================================
        UNIQUE CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @CSTCT_UQ_current_id                  tinyint;
    DECLARE @CSTCT_UQ_max_id                      tinyint;

    DECLARE @CSTCT_UQ_expected_name               sysname;
    DECLARE @CSTCT_UQ_expected_columns            nvarchar(4000);
    DECLARE @CSTCT_UQ_create_columns              nvarchar(4000);

    DECLARE @CSTCT_UQ_actual_name                 sysname;
    DECLARE @CSTCT_UQ_actual_columns              nvarchar(4000);
    DECLARE @CSTCT_UQ_actual_index_name           sysname;
    DECLARE @CSTCT_UQ_actual_is_disabled          bit;
    DECLARE @CSTCT_UQ_actual_data_space           sysname;

    DECLARE @CSTCT_UQ_equivalent_name             sysname;
    DECLARE @CSTCT_UQ_equivalent_columns          nvarchar(4000);
    DECLARE @CSTCT_UQ_equivalent_index_name       sysname;
    DECLARE @CSTCT_UQ_equivalent_is_disabled      bit;
    DECLARE @CSTCT_UQ_equivalent_data_space       sysname;

    DECLARE @CSTCT_UQ_unique_index_name           sysname;
    DECLARE @CSTCT_UQ_unique_index_columns        nvarchar(4000);
    DECLARE @CSTCT_UQ_unique_index_is_disabled    bit;
    DECLARE @CSTCT_UQ_unique_index_data_space     sysname;

    DECLARE @CSTCT_UQ_parent_object               nvarchar(517);
    DECLARE @CSTCT_UQ_qualified_name              nvarchar(517);

    DECLARE @CSTCT_UQ_sql                         nvarchar(max);


    SELECT
        @CSTCT_UQ_current_id = MIN(CSTCT_uq_id),
        @CSTCT_UQ_max_id     = MAX(CSTCT_uq_id)
    FROM @CSTCT_UQ_expected_uniques;


    WHILE @CSTCT_UQ_current_id <= @CSTCT_UQ_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT UNIQUE CONSTRAINT STATE
        ----------------------------------------------------------------------*/

        SET @CSTCT_UQ_expected_name              = NULL;
        SET @CSTCT_UQ_expected_columns           = NULL;
        SET @CSTCT_UQ_create_columns             = NULL;

        SET @CSTCT_UQ_actual_name                = NULL;
        SET @CSTCT_UQ_actual_columns             = NULL;
        SET @CSTCT_UQ_actual_index_name          = NULL;
        SET @CSTCT_UQ_actual_is_disabled         = NULL;
        SET @CSTCT_UQ_actual_data_space          = NULL;

        SET @CSTCT_UQ_equivalent_name            = NULL;
        SET @CSTCT_UQ_equivalent_columns         = NULL;
        SET @CSTCT_UQ_equivalent_index_name      = NULL;
        SET @CSTCT_UQ_equivalent_is_disabled     = NULL;
        SET @CSTCT_UQ_equivalent_data_space      = NULL;

        SET @CSTCT_UQ_unique_index_name          = NULL;
        SET @CSTCT_UQ_unique_index_columns       = NULL;
        SET @CSTCT_UQ_unique_index_is_disabled   = NULL;
        SET @CSTCT_UQ_unique_index_data_space    = NULL;

        SET @CSTCT_UQ_parent_object              = NULL;
        SET @CSTCT_UQ_qualified_name             = NULL;
        SET @CSTCT_UQ_sql                        = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @CSTCT_UQ_expected_name =
                CSTCT_uq_name,

            @CSTCT_UQ_expected_columns =
                CSTCT_expected_columns,

            @CSTCT_UQ_create_columns =
                CSTCT_create_columns

        FROM @CSTCT_UQ_expected_uniques
        WHERE CSTCT_uq_id = @CSTCT_UQ_current_id;


        /*----------------------------------------------------------------------
            LOOK FOR EXPECTED UNIQUE CONSTRAINT NAME
        ----------------------------------------------------------------------*/

        SELECT
            @CSTCT_UQ_actual_name =
                kc.name,

            @CSTCT_UQ_actual_index_name =
                i.name,

            @CSTCT_UQ_actual_is_disabled =
                i.is_disabled,

            @CSTCT_UQ_actual_data_space =
                ds.name,

            @CSTCT_UQ_actual_columns =
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

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'customer.CustomerType')

        AND kc.type = N'UQ'

        AND kc.name =
                @CSTCT_UQ_expected_name;


        /*======================================================================
            EXPECTED UNIQUE CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @CSTCT_UQ_actual_name IS NOT NULL
        BEGIN

            IF @CSTCT_UQ_actual_columns COLLATE Latin1_General_100_BIN2
                    =
               @CSTCT_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            AND @CSTCT_UQ_actual_is_disabled = 0

            AND @CSTCT_UQ_actual_data_space = N'FG_CORE'
            BEGIN

                PRINT N'        [•] Unique constraint validated     : '
                    + @CSTCT_UQ_expected_name;

                PRINT N'            Columns                         : '
                    + REPLACE
                    (
                        @CSTCT_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Filegroup                       : FG_CORE';

            END

            ELSE
            BEGIN

                PRINT N'        [!] Unique constraint mismatch      : '
                    + @CSTCT_UQ_expected_name;

                PRINT N'            Expected Name                   : '
                    + @CSTCT_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + COALESCE(@CSTCT_UQ_actual_name, N'<NULL>');

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @CSTCT_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + COALESCE
                    (
                        REPLACE
                        (
                            @CSTCT_UQ_actual_columns,
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
                            @CSTCT_UQ_actual_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @CSTCT_UQ_actual_data_space,
                        N'<NULL>'
                    );

                PRINT N'            Existing constraint was preserved for review.';

            END;

        END

        ELSE
        BEGIN

            /*------------------------------------------------------------------
                SEARCH FOR FUNCTIONALLY EQUIVALENT UQ WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            SELECT TOP (1)
                @CSTCT_UQ_equivalent_name =
                    uq.UQ_name,

                @CSTCT_UQ_equivalent_columns =
                    uq.UQ_columns,

                @CSTCT_UQ_equivalent_index_name =
                    uq.UQ_index_name,

                @CSTCT_UQ_equivalent_is_disabled =
                    uq.UQ_is_disabled,

                @CSTCT_UQ_equivalent_data_space =
                    uq.UQ_data_space

            FROM
            (
                SELECT
                    kc.name AS UQ_name,
                    i.name AS UQ_index_name,
                    i.is_disabled AS UQ_is_disabled,
                    ds.name AS UQ_data_space,

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

                INNER JOIN sys.data_spaces AS ds
                    ON ds.data_space_id = i.data_space_id

                WHERE kc.parent_object_id =
                        OBJECT_ID(N'customer.CustomerType')

                AND kc.type = N'UQ'

                AND kc.name <>
                        @CSTCT_UQ_expected_name

            ) AS uq

            WHERE uq.UQ_columns COLLATE Latin1_General_100_BIN2
                    =
                  @CSTCT_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            ORDER BY
                uq.UQ_name;


            /*------------------------------------------------------------------
                EQUIVALENT UNIQUE CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @CSTCT_UQ_equivalent_name IS NOT NULL
            BEGIN

                PRINT N'        [!] Unique constraint naming mismatch';

                PRINT N'            Expected Name                   : '
                    + @CSTCT_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + @CSTCT_UQ_equivalent_name;

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @CSTCT_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + REPLACE
                    (
                        @CSTCT_UQ_equivalent_columns,
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
                            @CSTCT_UQ_equivalent_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @CSTCT_UQ_equivalent_data_space,
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
                    @CSTCT_UQ_unique_index_name =
                        idx.IndexName,

                    @CSTCT_UQ_unique_index_columns =
                        idx.IndexColumns,

                    @CSTCT_UQ_unique_index_is_disabled =
                        idx.IsDisabled,

                    @CSTCT_UQ_unique_index_data_space =
                        idx.DataSpaceName

                FROM
                (
                    SELECT
                        i.name AS IndexName,
                        i.is_disabled AS IsDisabled,
                        ds.name AS DataSpaceName,

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

                    INNER JOIN sys.data_spaces AS ds
                        ON ds.data_space_id = i.data_space_id

                    WHERE i.object_id =
                            OBJECT_ID(N'customer.CustomerType')

                    AND i.is_unique = 1
                    AND i.is_unique_constraint = 0
                    AND i.is_primary_key = 0
                    AND i.is_hypothetical = 0

                ) AS idx

                WHERE idx.IndexColumns COLLATE Latin1_General_100_BIN2
                        =
                      @CSTCT_UQ_expected_columns COLLATE Latin1_General_100_BIN2

                ORDER BY
                    idx.IndexName;


                /*--------------------------------------------------------------
                    UNIQUE INDEX EXISTS BUT REQUIRED UQ DOES NOT
                --------------------------------------------------------------*/

                IF @CSTCT_UQ_unique_index_name IS NOT NULL
                BEGIN

                    PRINT N'        [!] Unique constraint type mismatch  : '
                        + @CSTCT_UQ_expected_name;

                    PRINT N'            Expected Object Type            : UNIQUE CONSTRAINT';
                    PRINT N'            Actual Object Type              : UNIQUE INDEX';

                    PRINT N'            Actual Index                    : '
                        + @CSTCT_UQ_unique_index_name;

                    PRINT N'            Expected Columns                : '
                        + REPLACE
                        (
                            @CSTCT_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Actual Columns                  : '
                        + REPLACE
                        (
                            @CSTCT_UQ_unique_index_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Expected Filegroup              : FG_CORE';

                    PRINT N'            Actual Filegroup                : '
                        + COALESCE
                        (
                            @CSTCT_UQ_unique_index_data_space,
                            N'<NULL>'
                        );

                    PRINT N'            Existing unique index was preserved for review.';
                    PRINT N'            Unique constraint was not created to avoid duplicate structures.';

                END

                ELSE
                BEGIN

                    /*----------------------------------------------------------
                        VALIDATE THAT EXPECTED NAME IS NOT USED ELSEWHERE
                    ----------------------------------------------------------*/

                    SET @CSTCT_UQ_qualified_name =
                        N'customer.'
                        + @CSTCT_UQ_expected_name;


                    IF OBJECT_ID
                    (
                        @CSTCT_UQ_qualified_name,
                        N'UQ'
                    ) IS NOT NULL
                    BEGIN

                        SELECT
                            @CSTCT_UQ_parent_object =
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
                                @CSTCT_UQ_qualified_name,
                                N'UQ'
                            );


                        PRINT N'        [!] Unique constraint name conflict : '
                            + @CSTCT_UQ_expected_name;

                        PRINT N'            Expected Table                  : customer.CustomerType';

                        PRINT N'            Existing Parent                 : '
                            + COALESCE
                            (
                                @CSTCT_UQ_parent_object,
                                N'<UNKNOWN>'
                            );

                        PRINT N'            Constraint was not created. Manual review is required.';


                        ;THROW 50320,
                            N'Unique constraint name conflict prevents safe deployment.',
                            1;

                    END;


                    /*----------------------------------------------------------
                        CREATE EXPECTED UNIQUE CONSTRAINT
                    ----------------------------------------------------------*/

                    SET @CSTCT_UQ_sql =
                        N'ALTER TABLE customer.CustomerType
                            ADD CONSTRAINT '
                        + QUOTENAME(@CSTCT_UQ_expected_name)
                        + N'
                            UNIQUE NONCLUSTERED
                            (
                                '
                        + @CSTCT_UQ_create_columns
                        + N'
                            )
                            ON FG_CORE;';


                    EXEC sys.sp_executesql
                        @CSTCT_UQ_sql;


                    PRINT N'        [+] Unique constraint added         : '
                        + @CSTCT_UQ_expected_name;

                    PRINT N'            Columns                         : '
                        + REPLACE
                        (
                            @CSTCT_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Filegroup                       : FG_CORE';

                END;

            END;

        END;


        SET @CSTCT_UQ_current_id =
            @CSTCT_UQ_current_id + 1;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';