    PRINT N'    customer.CustomerDocumentType';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        EXPECTED UNIQUE CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @DTP_UQ_expected_uniques TABLE
    (
        DTP_uq_id               tinyint IDENTITY(1,1) NOT NULL,
        DTP_uq_name             sysname               NOT NULL,
        DTP_expected_columns    nvarchar(4000)         NOT NULL,
        DTP_create_columns      nvarchar(4000)         NOT NULL
    );


    /*--------------------------------------------------------------------------
        UQ_DTP_name

        Rule:
            Each customer document type must have a unique name.

            The name provides the controlled identifier used by CustomerDocument
            and prevents duplicate document type definitions.
    --------------------------------------------------------------------------*/

    INSERT INTO @DTP_UQ_expected_uniques
    (
        DTP_uq_name,
        DTP_expected_columns,
        DTP_create_columns
    )
    VALUES
    (
        N'UQ_DTP_name',
        N'DTP_name',
        N'[DTP_name]'
    );


    /*==========================================================================
        UNIQUE CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @DTP_UQ_current_id                  tinyint;
    DECLARE @DTP_UQ_max_id                      tinyint;

    DECLARE @DTP_UQ_expected_name               sysname;
    DECLARE @DTP_UQ_expected_columns            nvarchar(4000);
    DECLARE @DTP_UQ_create_columns              nvarchar(4000);

    DECLARE @DTP_UQ_actual_name                 sysname;
    DECLARE @DTP_UQ_actual_columns              nvarchar(4000);
    DECLARE @DTP_UQ_actual_index_name           sysname;
    DECLARE @DTP_UQ_actual_is_disabled          bit;
    DECLARE @DTP_UQ_actual_data_space           sysname;

    DECLARE @DTP_UQ_equivalent_name             sysname;
    DECLARE @DTP_UQ_equivalent_columns          nvarchar(4000);
    DECLARE @DTP_UQ_equivalent_index_name       sysname;
    DECLARE @DTP_UQ_equivalent_is_disabled      bit;
    DECLARE @DTP_UQ_equivalent_data_space       sysname;

    DECLARE @DTP_UQ_unique_index_name           sysname;
    DECLARE @DTP_UQ_unique_index_columns        nvarchar(4000);
    DECLARE @DTP_UQ_unique_index_is_disabled    bit;
    DECLARE @DTP_UQ_unique_index_data_space     sysname;

    DECLARE @DTP_UQ_parent_object               nvarchar(517);
    DECLARE @DTP_UQ_qualified_name              nvarchar(517);

    DECLARE @DTP_UQ_sql                         nvarchar(max);


    SELECT
        @DTP_UQ_current_id = MIN(DTP_uq_id),
        @DTP_UQ_max_id     = MAX(DTP_uq_id)
    FROM @DTP_UQ_expected_uniques;


    WHILE @DTP_UQ_current_id <= @DTP_UQ_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT UNIQUE CONSTRAINT STATE
        ----------------------------------------------------------------------*/

        SET @DTP_UQ_expected_name              = NULL;
        SET @DTP_UQ_expected_columns           = NULL;
        SET @DTP_UQ_create_columns             = NULL;

        SET @DTP_UQ_actual_name                = NULL;
        SET @DTP_UQ_actual_columns             = NULL;
        SET @DTP_UQ_actual_index_name          = NULL;
        SET @DTP_UQ_actual_is_disabled         = NULL;
        SET @DTP_UQ_actual_data_space          = NULL;

        SET @DTP_UQ_equivalent_name            = NULL;
        SET @DTP_UQ_equivalent_columns         = NULL;
        SET @DTP_UQ_equivalent_index_name      = NULL;
        SET @DTP_UQ_equivalent_is_disabled     = NULL;
        SET @DTP_UQ_equivalent_data_space      = NULL;

        SET @DTP_UQ_unique_index_name          = NULL;
        SET @DTP_UQ_unique_index_columns       = NULL;
        SET @DTP_UQ_unique_index_is_disabled   = NULL;
        SET @DTP_UQ_unique_index_data_space    = NULL;

        SET @DTP_UQ_parent_object              = NULL;
        SET @DTP_UQ_qualified_name             = NULL;
        SET @DTP_UQ_sql                        = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @DTP_UQ_expected_name =
                DTP_uq_name,

            @DTP_UQ_expected_columns =
                DTP_expected_columns,

            @DTP_UQ_create_columns =
                DTP_create_columns

        FROM @DTP_UQ_expected_uniques
        WHERE DTP_uq_id = @DTP_UQ_current_id;


        /*----------------------------------------------------------------------
            LOOK FOR EXPECTED UNIQUE CONSTRAINT NAME
        ----------------------------------------------------------------------*/

        SELECT
            @DTP_UQ_actual_name =
                kc.name,

            @DTP_UQ_actual_index_name =
                i.name,

            @DTP_UQ_actual_is_disabled =
                i.is_disabled,

            @DTP_UQ_actual_data_space =
                ds.name,

            @DTP_UQ_actual_columns =
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
                OBJECT_ID(N'customer.CustomerDocumentType')

        AND kc.type = N'UQ'

        AND kc.name =
                @DTP_UQ_expected_name;


        /*======================================================================
            EXPECTED UNIQUE CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @DTP_UQ_actual_name IS NOT NULL
        BEGIN

            IF @DTP_UQ_actual_columns COLLATE Latin1_General_100_BIN2
                    =
            @DTP_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            AND @DTP_UQ_actual_is_disabled = 0

            AND @DTP_UQ_actual_data_space = N'FG_CORE'
            BEGIN

                PRINT N'        [•] Unique constraint validated     : '
                    + @DTP_UQ_expected_name;

                PRINT N'            Columns                         : '
                    + REPLACE
                    (
                        @DTP_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Filegroup                       : FG_CORE';

            END

            ELSE
            BEGIN

                PRINT N'        [!] Unique constraint mismatch      : '
                    + @DTP_UQ_expected_name;

                PRINT N'            Expected Name                   : '
                    + @DTP_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + COALESCE(@DTP_UQ_actual_name, N'<NULL>');

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @DTP_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + COALESCE
                    (
                        REPLACE
                        (
                            @DTP_UQ_actual_columns,
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
                            @DTP_UQ_actual_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @DTP_UQ_actual_data_space,
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
                @DTP_UQ_equivalent_name =
                    uq.UQ_name,

                @DTP_UQ_equivalent_columns =
                    uq.UQ_columns,

                @DTP_UQ_equivalent_index_name =
                    uq.UQ_index_name,

                @DTP_UQ_equivalent_is_disabled =
                    uq.UQ_is_disabled,

                @DTP_UQ_equivalent_data_space =
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
                        OBJECT_ID(N'customer.CustomerDocumentType')

                AND kc.type = N'UQ'

                AND kc.name <>
                        @DTP_UQ_expected_name

            ) AS uq

            WHERE uq.UQ_columns COLLATE Latin1_General_100_BIN2
                    =
                @DTP_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            ORDER BY uq.UQ_name;


            /*------------------------------------------------------------------
                EQUIVALENT UNIQUE CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @DTP_UQ_equivalent_name IS NOT NULL
            BEGIN

                PRINT N'        [!] Unique constraint naming mismatch';

                PRINT N'            Expected Name                   : '
                    + @DTP_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + @DTP_UQ_equivalent_name;

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @DTP_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + REPLACE
                    (
                        @DTP_UQ_equivalent_columns,
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
                            @DTP_UQ_equivalent_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @DTP_UQ_equivalent_data_space,
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
                    @DTP_UQ_unique_index_name =
                        idx.IndexName,

                    @DTP_UQ_unique_index_columns =
                        idx.IndexColumns,

                    @DTP_UQ_unique_index_is_disabled =
                        idx.IsDisabled,

                    @DTP_UQ_unique_index_data_space =
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
                            OBJECT_ID(N'customer.CustomerDocumentType')

                    AND i.is_unique = 1
                    AND i.is_unique_constraint = 0
                    AND i.is_primary_key = 0
                    AND i.is_hypothetical = 0

                ) AS idx

                WHERE idx.IndexColumns COLLATE Latin1_General_100_BIN2
                        =
                    @DTP_UQ_expected_columns COLLATE Latin1_General_100_BIN2

                ORDER BY idx.IndexName;


                /*--------------------------------------------------------------
                    UNIQUE INDEX EXISTS BUT REQUIRED UQ DOES NOT
                --------------------------------------------------------------*/

                IF @DTP_UQ_unique_index_name IS NOT NULL
                BEGIN

                    PRINT N'        [!] Unique constraint type mismatch  : '
                        + @DTP_UQ_expected_name;

                    PRINT N'            Expected Object Type            : UNIQUE CONSTRAINT';
                    PRINT N'            Actual Object Type              : UNIQUE INDEX';

                    PRINT N'            Actual Index                    : '
                        + @DTP_UQ_unique_index_name;

                    PRINT N'            Expected Columns                : '
                        + REPLACE
                        (
                            @DTP_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Actual Columns                  : '
                        + REPLACE
                        (
                            @DTP_UQ_unique_index_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Expected Filegroup              : FG_CORE';

                    PRINT N'            Actual Filegroup                : '
                        + COALESCE
                        (
                            @DTP_UQ_unique_index_data_space,
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

                    SET @DTP_UQ_qualified_name =
                        N'customer.'
                        + @DTP_UQ_expected_name;


                    IF OBJECT_ID
                    (
                        @DTP_UQ_qualified_name,
                        N'UQ'
                    ) IS NOT NULL
                    BEGIN

                        SELECT
                            @DTP_UQ_parent_object =
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
                                @DTP_UQ_qualified_name,
                                N'UQ'
                            );


                        PRINT N'        [!] Unique constraint name conflict : '
                            + @DTP_UQ_expected_name;

                        PRINT N'            Expected Table                  : customer.CustomerDocumentType';

                        PRINT N'            Existing Parent                 : '
                            + COALESCE
                            (
                                @DTP_UQ_parent_object,
                                N'<UNKNOWN>'
                            );

                        PRINT N'            Constraint was not created. Manual review is required.';


                        ;THROW 50520,
                            N'Unique constraint name conflict prevents safe deployment.',
                            1;

                    END;


                    /*----------------------------------------------------------
                        CREATE EXPECTED UNIQUE CONSTRAINT
                    ----------------------------------------------------------*/

                    SET @DTP_UQ_sql =
                        N'ALTER TABLE customer.CustomerDocumentType
                            ADD CONSTRAINT '
                        + QUOTENAME(@DTP_UQ_expected_name)
                        + N'
                            UNIQUE NONCLUSTERED
                            (
                                '
                        + @DTP_UQ_create_columns
                        + N'
                            )
                            ON FG_CORE;';


                    EXEC sys.sp_executesql
                        @DTP_UQ_sql;


                    PRINT N'        [+] Unique constraint added         : '
                        + @DTP_UQ_expected_name;

                    PRINT N'            Columns                         : '
                        + REPLACE
                        (
                            @DTP_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Filegroup                       : FG_CORE';

                END;

            END;

        END;


        SET @DTP_UQ_current_id =
            @DTP_UQ_current_id + 1;

    END;


    PRINT N'';