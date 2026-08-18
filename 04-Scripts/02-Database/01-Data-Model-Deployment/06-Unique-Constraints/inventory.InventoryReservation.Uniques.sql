    PRINT N'    inventory.InventoryReservation';
    PRINT N'    --------------------------------------------------------------------------';


    /*==========================================================================
        EXPECTED UNIQUE CONSTRAINT DEFINITIONS
    ==========================================================================*/

    DECLARE @INVRE_UQ_expected_uniques TABLE
    (
        INVRE_uq_id               tinyint IDENTITY(1,1) NOT NULL,
        INVRE_uq_name             sysname               NOT NULL,
        INVRE_expected_columns    nvarchar(4000)         NOT NULL,
        INVRE_create_columns      nvarchar(4000)         NOT NULL
    );


    /*--------------------------------------------------------------------------
        UQ_INVRE_TRNIT

        Rule:
            Each sales.TransactionItem may have at most one inventory
            reservation.

            Because sales.TransactionItem uses a composite primary key,
            both TRNIT_id and TRNIT_transaction_at participate in the
            reservation uniqueness rule.
    --------------------------------------------------------------------------*/

    INSERT INTO @INVRE_UQ_expected_uniques
    (
        INVRE_uq_name,
        INVRE_expected_columns,
        INVRE_create_columns
    )
    VALUES
    (
        N'UQ_INVRE_TRNIT',
        N'INVRE_TRNIT_id|INVRE_TRNIT_transaction_at',
        N'[INVRE_TRNIT_id], [INVRE_TRNIT_transaction_at]'
    );


    /*==========================================================================
        UNIQUE CONSTRAINT DEPLOYMENT ENGINE
    ==========================================================================*/

    DECLARE @INVRE_UQ_current_id                  tinyint;
    DECLARE @INVRE_UQ_max_id                      tinyint;

    DECLARE @INVRE_UQ_expected_name               sysname;
    DECLARE @INVRE_UQ_expected_columns            nvarchar(4000);
    DECLARE @INVRE_UQ_create_columns              nvarchar(4000);

    DECLARE @INVRE_UQ_actual_name                 sysname;
    DECLARE @INVRE_UQ_actual_columns              nvarchar(4000);
    DECLARE @INVRE_UQ_actual_index_name           sysname;
    DECLARE @INVRE_UQ_actual_is_disabled          bit;
    DECLARE @INVRE_UQ_actual_data_space           sysname;

    DECLARE @INVRE_UQ_equivalent_name             sysname;
    DECLARE @INVRE_UQ_equivalent_columns          nvarchar(4000);
    DECLARE @INVRE_UQ_equivalent_index_name       sysname;
    DECLARE @INVRE_UQ_equivalent_is_disabled      bit;
    DECLARE @INVRE_UQ_equivalent_data_space       sysname;

    DECLARE @INVRE_UQ_unique_index_name           sysname;
    DECLARE @INVRE_UQ_unique_index_columns        nvarchar(4000);
    DECLARE @INVRE_UQ_unique_index_is_disabled    bit;
    DECLARE @INVRE_UQ_unique_index_data_space     sysname;

    DECLARE @INVRE_UQ_parent_object               nvarchar(517);
    DECLARE @INVRE_UQ_qualified_name              nvarchar(517);

    DECLARE @INVRE_UQ_sql                         nvarchar(max);


    SELECT
        @INVRE_UQ_current_id = MIN(INVRE_uq_id),
        @INVRE_UQ_max_id     = MAX(INVRE_uq_id)
    FROM @INVRE_UQ_expected_uniques;


    WHILE @INVRE_UQ_current_id <= @INVRE_UQ_max_id
    BEGIN

        /*----------------------------------------------------------------------
            RESET CURRENT UNIQUE CONSTRAINT STATE
        ----------------------------------------------------------------------*/

        SET @INVRE_UQ_expected_name              = NULL;
        SET @INVRE_UQ_expected_columns           = NULL;
        SET @INVRE_UQ_create_columns             = NULL;

        SET @INVRE_UQ_actual_name                = NULL;
        SET @INVRE_UQ_actual_columns             = NULL;
        SET @INVRE_UQ_actual_index_name          = NULL;
        SET @INVRE_UQ_actual_is_disabled         = NULL;
        SET @INVRE_UQ_actual_data_space          = NULL;

        SET @INVRE_UQ_equivalent_name            = NULL;
        SET @INVRE_UQ_equivalent_columns         = NULL;
        SET @INVRE_UQ_equivalent_index_name      = NULL;
        SET @INVRE_UQ_equivalent_is_disabled     = NULL;
        SET @INVRE_UQ_equivalent_data_space      = NULL;

        SET @INVRE_UQ_unique_index_name          = NULL;
        SET @INVRE_UQ_unique_index_columns       = NULL;
        SET @INVRE_UQ_unique_index_is_disabled   = NULL;
        SET @INVRE_UQ_unique_index_data_space    = NULL;

        SET @INVRE_UQ_parent_object              = NULL;
        SET @INVRE_UQ_qualified_name             = NULL;
        SET @INVRE_UQ_sql                        = NULL;


        /*----------------------------------------------------------------------
            LOAD EXPECTED DEFINITION
        ----------------------------------------------------------------------*/

        SELECT
            @INVRE_UQ_expected_name =
                INVRE_uq_name,

            @INVRE_UQ_expected_columns =
                INVRE_expected_columns,

            @INVRE_UQ_create_columns =
                INVRE_create_columns

        FROM @INVRE_UQ_expected_uniques

        WHERE INVRE_uq_id =
                @INVRE_UQ_current_id;


        /*----------------------------------------------------------------------
            LOOK FOR EXPECTED UNIQUE CONSTRAINT NAME
        ----------------------------------------------------------------------*/

        SELECT
            @INVRE_UQ_actual_name =
                kc.name,

            @INVRE_UQ_actual_index_name =
                i.name,

            @INVRE_UQ_actual_is_disabled =
                i.is_disabled,

            @INVRE_UQ_actual_data_space =
                ds.name,

            @INVRE_UQ_actual_columns =
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
            )

        FROM sys.key_constraints AS kc

        INNER JOIN sys.indexes AS i
            ON  i.object_id = kc.parent_object_id
            AND i.index_id = kc.unique_index_id

        INNER JOIN sys.data_spaces AS ds
            ON ds.data_space_id = i.data_space_id

        WHERE kc.parent_object_id =
                OBJECT_ID(N'inventory.InventoryReservation')

        AND kc.type =
                N'UQ'

        AND kc.name =
                @INVRE_UQ_expected_name;


        /*======================================================================
            EXPECTED UNIQUE CONSTRAINT NAME EXISTS
        ======================================================================*/

        IF @INVRE_UQ_actual_name IS NOT NULL
        BEGIN

            IF @INVRE_UQ_actual_columns COLLATE Latin1_General_100_BIN2
                    =
            @INVRE_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            AND @INVRE_UQ_actual_is_disabled = 0

            AND @INVRE_UQ_actual_data_space = N'FG_CORE'
            BEGIN

                PRINT N'        [•] Unique constraint validated     : '
                    + @INVRE_UQ_expected_name;

                PRINT N'            Columns                         : '
                    + REPLACE
                    (
                        @INVRE_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Filegroup                       : FG_CORE';

            END
            ELSE
            BEGIN

                PRINT N'        [!] Unique constraint mismatch      : '
                    + @INVRE_UQ_expected_name;

                PRINT N'            Expected Name                   : '
                    + @INVRE_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + COALESCE(@INVRE_UQ_actual_name, N'<NULL>');

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @INVRE_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + COALESCE
                    (
                        REPLACE
                        (
                            @INVRE_UQ_actual_columns,
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
                            @INVRE_UQ_actual_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @INVRE_UQ_actual_data_space,
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
                @INVRE_UQ_equivalent_name =
                    uq.UQ_name,

                @INVRE_UQ_equivalent_columns =
                    uq.UQ_columns,

                @INVRE_UQ_equivalent_index_name =
                    uq.UQ_index_name,

                @INVRE_UQ_equivalent_is_disabled =
                    uq.UQ_is_disabled,

                @INVRE_UQ_equivalent_data_space =
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
                        OBJECT_ID(N'inventory.InventoryReservation')

                AND kc.type =
                        N'UQ'

                AND kc.name <>
                        @INVRE_UQ_expected_name

            ) AS uq

            WHERE uq.UQ_columns COLLATE Latin1_General_100_BIN2
                    =
                @INVRE_UQ_expected_columns COLLATE Latin1_General_100_BIN2

            ORDER BY uq.UQ_name;


            /*------------------------------------------------------------------
                EQUIVALENT UNIQUE CONSTRAINT EXISTS WITH ANOTHER NAME
            ------------------------------------------------------------------*/

            IF @INVRE_UQ_equivalent_name IS NOT NULL
            BEGIN

                PRINT N'        [!] Unique constraint naming mismatch';

                PRINT N'            Expected Name                   : '
                    + @INVRE_UQ_expected_name;

                PRINT N'            Actual Name                     : '
                    + @INVRE_UQ_equivalent_name;

                PRINT N'            Expected Columns                : '
                    + REPLACE
                    (
                        @INVRE_UQ_expected_columns,
                        N'|',
                        N', '
                    );

                PRINT N'            Actual Columns                  : '
                    + REPLACE
                    (
                        @INVRE_UQ_equivalent_columns,
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
                            @INVRE_UQ_equivalent_is_disabled
                        ),
                        N'<NULL>'
                    );

                PRINT N'            Expected Filegroup              : FG_CORE';

                PRINT N'            Actual Filegroup                : '
                    + COALESCE
                    (
                        @INVRE_UQ_equivalent_data_space,
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
                    @INVRE_UQ_unique_index_name =
                        idx.IndexName,

                    @INVRE_UQ_unique_index_columns =
                        idx.IndexColumns,

                    @INVRE_UQ_unique_index_is_disabled =
                        idx.IsDisabled,

                    @INVRE_UQ_unique_index_data_space =
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

                            WHERE ic.object_id =
                                    i.object_id

                            AND ic.index_id =
                                    i.index_id

                            AND ic.key_ordinal > 0

                        ) AS IndexColumns

                    FROM sys.indexes AS i

                    INNER JOIN sys.data_spaces AS ds
                        ON ds.data_space_id = i.data_space_id

                    WHERE i.object_id =
                            OBJECT_ID(N'inventory.InventoryReservation')

                    AND i.is_unique = 1

                    AND i.is_unique_constraint = 0

                    AND i.is_primary_key = 0

                    AND i.is_hypothetical = 0

                ) AS idx

                WHERE idx.IndexColumns COLLATE Latin1_General_100_BIN2
                        =
                    @INVRE_UQ_expected_columns COLLATE Latin1_General_100_BIN2

                ORDER BY idx.IndexName;


                /*--------------------------------------------------------------
                    UNIQUE INDEX EXISTS BUT REQUIRED UQ DOES NOT
                --------------------------------------------------------------*/

                IF @INVRE_UQ_unique_index_name IS NOT NULL
                BEGIN

                    PRINT N'        [!] Unique constraint type mismatch  : '
                        + @INVRE_UQ_expected_name;

                    PRINT N'            Expected Object Type            : UNIQUE CONSTRAINT';
                    PRINT N'            Actual Object Type              : UNIQUE INDEX';

                    PRINT N'            Actual Index                    : '
                        + @INVRE_UQ_unique_index_name;

                    PRINT N'            Expected Columns                : '
                        + REPLACE
                        (
                            @INVRE_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Actual Columns                  : '
                        + REPLACE
                        (
                            @INVRE_UQ_unique_index_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Expected Filegroup              : FG_CORE';

                    PRINT N'            Actual Filegroup                : '
                        + COALESCE
                        (
                            @INVRE_UQ_unique_index_data_space,
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

                    SET @INVRE_UQ_qualified_name =
                        N'inventory.'
                        + @INVRE_UQ_expected_name;


                    IF OBJECT_ID
                    (
                        @INVRE_UQ_qualified_name,
                        N'UQ'
                    ) IS NOT NULL
                    BEGIN

                        SELECT
                            @INVRE_UQ_parent_object =
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
                                @INVRE_UQ_qualified_name,
                                N'UQ'
                            );


                        PRINT N'        [!] Unique constraint name conflict : '
                            + @INVRE_UQ_expected_name;

                        PRINT N'            Expected Table                  : inventory.InventoryReservation';

                        PRINT N'            Existing Parent                 : '
                            + COALESCE
                            (
                                @INVRE_UQ_parent_object,
                                N'<UNKNOWN>'
                            );

                        PRINT N'            Constraint was not created. Manual review is required.';


                        ;THROW 50970,
                            N'Unique constraint name conflict prevents safe deployment.',
                            1;

                    END;


                    /*----------------------------------------------------------
                        CREATE EXPECTED UNIQUE CONSTRAINT
                    ----------------------------------------------------------*/

                    SET @INVRE_UQ_sql =
                        N'ALTER TABLE inventory.InventoryReservation
                            ADD CONSTRAINT '
                        + QUOTENAME(@INVRE_UQ_expected_name)
                        + N'
                            UNIQUE NONCLUSTERED
                            (
                                '
                        + @INVRE_UQ_create_columns
                        + N'
                            )
                            ON FG_CORE;';


                    EXEC sys.sp_executesql
                        @INVRE_UQ_sql;


                    PRINT N'        [+] Unique constraint added         : '
                        + @INVRE_UQ_expected_name;

                    PRINT N'            Columns                         : '
                        + REPLACE
                        (
                            @INVRE_UQ_expected_columns,
                            N'|',
                            N', '
                        );

                    PRINT N'            Filegroup                       : FG_CORE';

                END;

            END;

        END;


        SET @INVRE_UQ_current_id =
            @INVRE_UQ_current_id + 1;

    END;


    PRINT N'';