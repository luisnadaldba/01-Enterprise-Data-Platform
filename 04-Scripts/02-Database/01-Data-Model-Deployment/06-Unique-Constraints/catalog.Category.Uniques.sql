    PRINT N'';
    PRINT N'    ● catalog.Category';
    PRINT N'';


    /*==========================================================================
        EXPECTED UNIQUE CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @CTG_UQ_expected_uniques TABLE
    (
        CTG_uq_id               tinyint IDENTITY(1,1) NOT NULL,
        CTG_uq_name             sysname               NOT NULL,
        CTG_expected_columns    nvarchar(4000)         NOT NULL,
        CTG_create_columns      nvarchar(4000)         NOT NULL
    );


    /*--------------------------------------------------------------------------
        UQ_CTG_parent_name

        Rule:
            A category name must be unique within the same parent category.

            The same category name may exist under different parent
            categories because those rows represent different positions
            within the catalog hierarchy.
    --------------------------------------------------------------------------*/

    INSERT INTO @CTG_UQ_expected_uniques
    (
        CTG_uq_name,
        CTG_expected_columns,
        CTG_create_columns
    )
    VALUES
    (
        N'UQ_CTG_parent_name',
        N'CTG_CTG_id|CTG_name',
        N'[CTG_CTG_id],
                                [CTG_name]'
    );


    /*==========================================================================
        UNIQUE CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @CTG_UQ_current_id                  tinyint;
    DECLARE @CTG_UQ_max_id                      tinyint;

    DECLARE @CTG_UQ_expected_name               sysname;
    DECLARE @CTG_UQ_expected_columns            nvarchar(4000);
    DECLARE @CTG_UQ_create_columns              nvarchar(4000);

    DECLARE @CTG_UQ_actual_name                 sysname;
    DECLARE @CTG_UQ_actual_columns              nvarchar(4000);
    DECLARE @CTG_UQ_actual_index_name           sysname;
    DECLARE @CTG_UQ_actual_is_disabled          bit;
    DECLARE @CTG_UQ_actual_data_space           sysname;

    DECLARE @CTG_UQ_equivalent_name             sysname;
    DECLARE @CTG_UQ_equivalent_columns          nvarchar(4000);
    DECLARE @CTG_UQ_equivalent_index_name       sysname;
    DECLARE @CTG_UQ_equivalent_is_disabled      bit;
    DECLARE @CTG_UQ_equivalent_data_space       sysname;

    DECLARE @CTG_UQ_unique_index_name           sysname;
    DECLARE @CTG_UQ_unique_index_columns        nvarchar(4000);
    DECLARE @CTG_UQ_unique_index_is_disabled    bit;
    DECLARE @CTG_UQ_unique_index_data_space     sysname;

    DECLARE @CTG_UQ_parent_object               nvarchar(517);
    DECLARE @CTG_UQ_qualified_name              nvarchar(517);

    DECLARE @CTG_UQ_sql                         nvarchar(max);


    SELECT
        @CTG_UQ_current_id = MIN(CTG_uq_id),
        @CTG_UQ_max_id     = MAX(CTG_uq_id)
    FROM @CTG_UQ_expected_uniques;


    WHILE @CTG_UQ_current_id <= @CTG_UQ_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT UNIQUE CONSTRAINT STATE
        ----------------------------------------------------------------------*/

        SET @CTG_UQ_expected_name              = NULL;
        SET @CTG_UQ_expected_columns           = NULL;
        SET @CTG_UQ_create_columns             = NULL;

        SET @CTG_UQ_actual_name                = NULL;
        SET @CTG_UQ_actual_columns             = NULL;
        SET @CTG_UQ_actual_index_name          = NULL;
        SET @CTG_UQ_actual_is_disabled         = NULL;
        SET @CTG_UQ_actual_data_space          = NULL;

        SET @CTG_UQ_equivalent_name            = NULL;
        SET @CTG_UQ_equivalent_columns         = NULL;
        SET @CTG_UQ_equivalent_index_name      = NULL;
        SET @CTG_UQ_equivalent_is_disabled     = NULL;
        SET @CTG_UQ_equivalent_data_space      = NULL;

        SET @CTG_UQ_unique_index_name          = NULL;
        SET @CTG_UQ_unique_index_columns       = NULL;
        SET @CTG_UQ_unique_index_is_disabled   = NULL;
        SET @CTG_UQ_unique_index_data_space    = NULL;

        SET @CTG_UQ_parent_object              = NULL;
        SET @CTG_UQ_qualified_name             = NULL;
        SET @CTG_UQ_sql                        = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @CTG_UQ_expected_name =
                CTG_uq_name,

            @CTG_UQ_expected_columns =
                CTG_expected_columns,

            @CTG_UQ_create_columns =
                CTG_create_columns

        FROM @CTG_UQ_expected_uniques
        WHERE CTG_uq_id = @CTG_UQ_current_id;


        /*----------------------------------------------------------------------
            LOOK FOR EXPECTED UNIQUE CONSTRAINT NAME
        ----------------------------------------------------------------------*/

        SELECT
            @CTG_UQ_actual_name =
                kc.name,

            @CTG_UQ_actual_index_name =
                i.name,

            @CTG_UQ_actual_is_disabled =
                i.is_disabled,

            @CTG_UQ_actual_data_space =
                ds.name,

            @CTG_UQ_actual_columns =
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
                OBJECT_ID(N'catalog.Category')

        AND kc.type = N'UQ'

        AND kc.name =
                @CTG_UQ_expected_name;


        /*======================================================================
            EXPECTED UNIQUE CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @CTG_UQ_actual_name IS NOT NULL
        BEGIN

            IF @CTG_UQ_actual_columns COLLATE Latin1_General_100_BIN2
                    =
               @CTG_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            AND @CTG_UQ_actual_is_disabled = 0

            AND @CTG_UQ_actual_data_space = N'FG_CORE'
            BEGIN

                PRINT N'        [•] Unique constraint validated     : '
                    + @CTG_UQ_expected_name;

                PRINT N'            Columns                         : '
                    + REPLACE
                    (
                        @CTG_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Filegroup                       : FG_CORE';

            END

            ELSE
            BEGIN

                PRINT N'        [!] Unique constraint mismatch      : '
                    + @CTG_UQ_expected_name;

                PRINT N'            Expected Name                   : '
                    + @CTG_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + COALESCE(@CTG_UQ_actual_name, N'<NULL>');

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @CTG_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + COALESCE
                    (
                        REPLACE
                        (
                            @CTG_UQ_actual_columns,
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
                            @CTG_UQ_actual_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @CTG_UQ_actual_data_space,
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
                @CTG_UQ_equivalent_name =
                    uq.UQ_name,

                @CTG_UQ_equivalent_columns =
                    uq.UQ_columns,

                @CTG_UQ_equivalent_index_name =
                    uq.UQ_index_name,

                @CTG_UQ_equivalent_is_disabled =
                    uq.UQ_is_disabled,

                @CTG_UQ_equivalent_data_space =
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
                        OBJECT_ID(N'catalog.Category')

                AND kc.type = N'UQ'

                AND kc.name <>
                        @CTG_UQ_expected_name

            ) AS uq

            WHERE uq.UQ_columns COLLATE Latin1_General_100_BIN2
                    =
                  @CTG_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            ORDER BY uq.UQ_name;


            /*------------------------------------------------------------------
                EQUIVALENT UNIQUE CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @CTG_UQ_equivalent_name IS NOT NULL
            BEGIN

                PRINT N'        [!] Unique constraint naming mismatch';

                PRINT N'            Expected Name                   : '
                    + @CTG_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + @CTG_UQ_equivalent_name;

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @CTG_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + REPLACE
                    (
                        @CTG_UQ_equivalent_columns,
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
                            @CTG_UQ_equivalent_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @CTG_UQ_equivalent_data_space,
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
                    @CTG_UQ_unique_index_name =
                        idx.IndexName,

                    @CTG_UQ_unique_index_columns =
                        idx.IndexColumns,

                    @CTG_UQ_unique_index_is_disabled =
                        idx.IsDisabled,

                    @CTG_UQ_unique_index_data_space =
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
                            OBJECT_ID(N'catalog.Category')

                    AND i.is_unique = 1
                    AND i.is_unique_constraint = 0
                    AND i.is_primary_key = 0
                    AND i.is_hypothetical = 0

                ) AS idx

                WHERE idx.IndexColumns COLLATE Latin1_General_100_BIN2
                        =
                      @CTG_UQ_expected_columns COLLATE Latin1_General_100_BIN2

                ORDER BY idx.IndexName;


                /*--------------------------------------------------------------
                    UNIQUE INDEX EXISTS BUT REQUIRED UQ DOES NOT
                --------------------------------------------------------------*/

                IF @CTG_UQ_unique_index_name IS NOT NULL
                BEGIN

                    PRINT N'        [!] Unique constraint type mismatch  : '
                        + @CTG_UQ_expected_name;

                    PRINT N'            Expected Object Type            : UNIQUE CONSTRAINT';
                    PRINT N'            Actual Object Type              : UNIQUE INDEX';

                    PRINT N'            Actual Index                    : '
                        + @CTG_UQ_unique_index_name;

                    PRINT N'            Expected Columns                : '
                        + REPLACE
                        (
                            @CTG_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Actual Columns                  : '
                        + REPLACE
                        (
                            @CTG_UQ_unique_index_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Expected Filegroup              : FG_CORE';

                    PRINT N'            Actual Filegroup                : '
                        + COALESCE
                        (
                            @CTG_UQ_unique_index_data_space,
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

                    SET @CTG_UQ_qualified_name =
                        N'catalog.'
                        + @CTG_UQ_expected_name;


                    IF OBJECT_ID
                    (
                        @CTG_UQ_qualified_name,
                        N'UQ'
                    ) IS NOT NULL
                    BEGIN

                        SELECT
                            @CTG_UQ_parent_object =
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
                                @CTG_UQ_qualified_name,
                                N'UQ'
                            );


                        PRINT N'        [!] Unique constraint name conflict : '
                            + @CTG_UQ_expected_name;

                        PRINT N'            Expected Table                  : catalog.Category';

                        PRINT N'            Existing Parent                 : '
                            + COALESCE
                            (
                                @CTG_UQ_parent_object,
                                N'<UNKNOWN>'
                            );

                        PRINT N'            Constraint was not created. Manual review is required.';


                        ;THROW 50150,
                            N'Unique constraint name conflict prevents safe deployment.',
                            1;

                    END;


                    /*----------------------------------------------------------
                        CREATE EXPECTED UNIQUE CONSTRAINT
                    ----------------------------------------------------------*/

                    SET @CTG_UQ_sql =
                        N'ALTER TABLE catalog.Category
                            ADD CONSTRAINT '
                        + QUOTENAME(@CTG_UQ_expected_name)
                        + N'
                            UNIQUE NONCLUSTERED
                            (
                                '
                        + @CTG_UQ_create_columns
                        + N'
                            )
                            ON FG_CORE;';


                    EXEC sys.sp_executesql
                        @CTG_UQ_sql;


                    PRINT N'        [+] Unique constraint added         : '
                        + @CTG_UQ_expected_name;

                    PRINT N'            Columns                         : '
                        + REPLACE
                        (
                            @CTG_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Filegroup                       : FG_CORE';

                END;

            END;

        END;


        SET @CTG_UQ_current_id =
            @CTG_UQ_current_id + 1;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';