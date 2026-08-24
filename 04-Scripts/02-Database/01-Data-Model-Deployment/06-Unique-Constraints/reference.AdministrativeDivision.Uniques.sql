    PRINT N'';
    PRINT N'    ● reference.AdministrativeDivision';
    PRINT N'';


    /*==========================================================================
        EXPECTED UNIQUE CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @ADV_UQ_expected_uniques TABLE
    (
        ADV_uq_id               tinyint IDENTITY(1,1) NOT NULL,
        ADV_uq_name             sysname               NOT NULL,
        ADV_expected_columns    nvarchar(4000)         NOT NULL,
        ADV_create_columns      nvarchar(4000)         NOT NULL
    );


    /*--------------------------------------------------------------------------
        UQ_ADV_country_code

        Rule:
            An administrative division code must be unique within the same
            country.

            The same code may exist in different countries because the code
            identifies the administrative division only within its country.
    --------------------------------------------------------------------------*/

    INSERT INTO @ADV_UQ_expected_uniques
    (
        ADV_uq_name,
        ADV_expected_columns,
        ADV_create_columns
    )
    VALUES
    (
        N'UQ_ADV_country_code',
        N'ADV_CTR_id|ADV_code',
        N'[ADV_CTR_id],
                                [ADV_code]'
    );


    /*==========================================================================
        UNIQUE CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @ADV_UQ_current_id                  tinyint;
    DECLARE @ADV_UQ_max_id                      tinyint;

    DECLARE @ADV_UQ_expected_name               sysname;
    DECLARE @ADV_UQ_expected_columns            nvarchar(4000);
    DECLARE @ADV_UQ_create_columns              nvarchar(4000);

    DECLARE @ADV_UQ_actual_name                 sysname;
    DECLARE @ADV_UQ_actual_columns              nvarchar(4000);
    DECLARE @ADV_UQ_actual_index_name           sysname;
    DECLARE @ADV_UQ_actual_is_disabled          bit;
    DECLARE @ADV_UQ_actual_data_space           sysname;

    DECLARE @ADV_UQ_equivalent_name             sysname;
    DECLARE @ADV_UQ_equivalent_columns          nvarchar(4000);
    DECLARE @ADV_UQ_equivalent_index_name       sysname;
    DECLARE @ADV_UQ_equivalent_is_disabled      bit;
    DECLARE @ADV_UQ_equivalent_data_space       sysname;

    DECLARE @ADV_UQ_unique_index_name           sysname;
    DECLARE @ADV_UQ_unique_index_columns        nvarchar(4000);
    DECLARE @ADV_UQ_unique_index_is_disabled    bit;
    DECLARE @ADV_UQ_unique_index_data_space     sysname;

    DECLARE @ADV_UQ_parent_object               nvarchar(517);
    DECLARE @ADV_UQ_qualified_name              nvarchar(517);

    DECLARE @ADV_UQ_sql                         nvarchar(max);


    SELECT
        @ADV_UQ_current_id = MIN(ADV_uq_id),
        @ADV_UQ_max_id     = MAX(ADV_uq_id)
    FROM @ADV_UQ_expected_uniques;


    WHILE @ADV_UQ_current_id <= @ADV_UQ_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT UNIQUE CONSTRAINT STATE
        ----------------------------------------------------------------------*/

        SET @ADV_UQ_expected_name              = NULL;
        SET @ADV_UQ_expected_columns           = NULL;
        SET @ADV_UQ_create_columns             = NULL;

        SET @ADV_UQ_actual_name                = NULL;
        SET @ADV_UQ_actual_columns             = NULL;
        SET @ADV_UQ_actual_index_name          = NULL;
        SET @ADV_UQ_actual_is_disabled         = NULL;
        SET @ADV_UQ_actual_data_space          = NULL;

        SET @ADV_UQ_equivalent_name            = NULL;
        SET @ADV_UQ_equivalent_columns         = NULL;
        SET @ADV_UQ_equivalent_index_name      = NULL;
        SET @ADV_UQ_equivalent_is_disabled     = NULL;
        SET @ADV_UQ_equivalent_data_space      = NULL;

        SET @ADV_UQ_unique_index_name          = NULL;
        SET @ADV_UQ_unique_index_columns       = NULL;
        SET @ADV_UQ_unique_index_is_disabled   = NULL;
        SET @ADV_UQ_unique_index_data_space    = NULL;

        SET @ADV_UQ_parent_object              = NULL;
        SET @ADV_UQ_qualified_name             = NULL;
        SET @ADV_UQ_sql                        = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @ADV_UQ_expected_name =
                ADV_uq_name,

            @ADV_UQ_expected_columns =
                ADV_expected_columns,

            @ADV_UQ_create_columns =
                ADV_create_columns

        FROM @ADV_UQ_expected_uniques
        WHERE ADV_uq_id = @ADV_UQ_current_id;


        /*----------------------------------------------------------------------
            LOOK FOR EXPECTED UNIQUE CONSTRAINT NAME
        ----------------------------------------------------------------------*/

        SELECT
            @ADV_UQ_actual_name =
                kc.name,

            @ADV_UQ_actual_index_name =
                i.name,

            @ADV_UQ_actual_is_disabled =
                i.is_disabled,

            @ADV_UQ_actual_data_space =
                ds.name,

            @ADV_UQ_actual_columns =
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
                OBJECT_ID(N'reference.AdministrativeDivision')

        AND kc.type = N'UQ'

        AND kc.name =
                @ADV_UQ_expected_name;


        /*======================================================================
            EXPECTED UNIQUE CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @ADV_UQ_actual_name IS NOT NULL
        BEGIN

            IF @ADV_UQ_actual_columns COLLATE Latin1_General_100_BIN2
                    =
            @ADV_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            AND @ADV_UQ_actual_is_disabled = 0

            AND @ADV_UQ_actual_data_space = N'FG_CORE'
            BEGIN

                PRINT N'        [•] Unique constraint validated     : '
                    + @ADV_UQ_expected_name;

                PRINT N'            Columns                         : '
                    + REPLACE
                    (
                        @ADV_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Filegroup                       : FG_CORE';

            END

            ELSE
            BEGIN

                PRINT N'        [!] Unique constraint mismatch      : '
                    + @ADV_UQ_expected_name;

                PRINT N'            Expected Name                   : '
                    + @ADV_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + COALESCE(@ADV_UQ_actual_name, N'<NULL>');

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @ADV_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + COALESCE
                    (
                        REPLACE
                        (
                            @ADV_UQ_actual_columns,
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
                            @ADV_UQ_actual_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @ADV_UQ_actual_data_space,
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
                @ADV_UQ_equivalent_name =
                    uq.UQ_name,

                @ADV_UQ_equivalent_columns =
                    uq.UQ_columns,

                @ADV_UQ_equivalent_index_name =
                    uq.UQ_index_name,

                @ADV_UQ_equivalent_is_disabled =
                    uq.UQ_is_disabled,

                @ADV_UQ_equivalent_data_space =
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
                        OBJECT_ID(N'reference.AdministrativeDivision')

                AND kc.type = N'UQ'

                AND kc.name <>
                        @ADV_UQ_expected_name

            ) AS uq

            WHERE uq.UQ_columns COLLATE Latin1_General_100_BIN2
                    =
                @ADV_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            ORDER BY uq.UQ_name;


            /*------------------------------------------------------------------
                EQUIVALENT UNIQUE CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @ADV_UQ_equivalent_name IS NOT NULL
            BEGIN

                PRINT N'        [!] Unique constraint naming mismatch';

                PRINT N'            Expected Name                   : '
                    + @ADV_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + @ADV_UQ_equivalent_name;

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @ADV_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + REPLACE
                    (
                        @ADV_UQ_equivalent_columns,
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
                            @ADV_UQ_equivalent_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @ADV_UQ_equivalent_data_space,
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
                    @ADV_UQ_unique_index_name =
                        idx.IndexName,

                    @ADV_UQ_unique_index_columns =
                        idx.IndexColumns,

                    @ADV_UQ_unique_index_is_disabled =
                        idx.IsDisabled,

                    @ADV_UQ_unique_index_data_space =
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
                            OBJECT_ID(N'reference.AdministrativeDivision')

                    AND i.is_unique = 1
                    AND i.is_unique_constraint = 0
                    AND i.is_primary_key = 0
                    AND i.is_hypothetical = 0

                ) AS idx

                WHERE idx.IndexColumns COLLATE Latin1_General_100_BIN2
                        =
                    @ADV_UQ_expected_columns COLLATE Latin1_General_100_BIN2

                ORDER BY idx.IndexName;


                /*--------------------------------------------------------------
                    UNIQUE INDEX EXISTS BUT REQUIRED UQ DOES NOT
                --------------------------------------------------------------*/

                IF @ADV_UQ_unique_index_name IS NOT NULL
                BEGIN

                    PRINT N'        [!] Unique constraint type mismatch  : '
                        + @ADV_UQ_expected_name;

                    PRINT N'            Expected Object Type            : UNIQUE CONSTRAINT';
                    PRINT N'            Actual Object Type              : UNIQUE INDEX';

                    PRINT N'            Actual Index                    : '
                        + @ADV_UQ_unique_index_name;

                    PRINT N'            Expected Columns                : '
                        + REPLACE
                        (
                            @ADV_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Actual Columns                  : '
                        + REPLACE
                        (
                            @ADV_UQ_unique_index_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Expected Filegroup              : FG_CORE';

                    PRINT N'            Actual Filegroup                : '
                        + COALESCE
                        (
                            @ADV_UQ_unique_index_data_space,
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

                    SET @ADV_UQ_qualified_name =
                        N'reference.'
                        + @ADV_UQ_expected_name;


                    IF OBJECT_ID
                    (
                        @ADV_UQ_qualified_name,
                        N'UQ'
                    ) IS NOT NULL
                    BEGIN

                        SELECT
                            @ADV_UQ_parent_object =
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
                                @ADV_UQ_qualified_name,
                                N'UQ'
                            );


                        PRINT N'        [!] Unique constraint name conflict : '
                            + @ADV_UQ_expected_name;

                        PRINT N'            Expected Table                  : reference.AdministrativeDivision';

                        PRINT N'            Existing Parent                 : '
                            + COALESCE
                            (
                                @ADV_UQ_parent_object,
                                N'<UNKNOWN>'
                            );

                        PRINT N'            Constraint was not created. Manual review is required.';


                        ;THROW 50180,
                            N'Unique constraint name conflict prevents safe deployment.',
                            1;

                    END;


                    /*----------------------------------------------------------
                        CREATE EXPECTED UNIQUE CONSTRAINT
                    ----------------------------------------------------------*/

                    SET @ADV_UQ_sql =
                        N'ALTER TABLE reference.AdministrativeDivision
                            ADD CONSTRAINT '
                        + QUOTENAME(@ADV_UQ_expected_name)
                        + N'
                            UNIQUE NONCLUSTERED
                            (
                                '
                        + @ADV_UQ_create_columns
                        + N'
                            )
                            ON FG_CORE;';


                    EXEC sys.sp_executesql
                        @ADV_UQ_sql;


                    PRINT N'        [+] Unique constraint added         : '
                        + @ADV_UQ_expected_name;

                    PRINT N'            Columns                         : '
                        + REPLACE
                        (
                            @ADV_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Filegroup                       : FG_CORE';

                END;

            END;

        END;


        SET @ADV_UQ_current_id =
            @ADV_UQ_current_id + 1;

    END;


    PRINT N'';
    PRINT N'    --------------------------------------------------------------------------';
    PRINT N'';